function [dtw_cost, newpath] = alignScore_path( midi_path, f0_wav, wav, fs_w, wSize, hop )
%ALIGNSCORE: Uses dynamic time warping to align the original score of
%the current exercise with the picth contour of the student performance
%   INPUT:
%       midi_path:  path to the ground truth MIDI score
%       f0_wav:     pitch contour of the student performance
%       wav:        student performance, for onset detection
%       fs_w:       sample rate of student performance
%       wSize:      window size used in pitch estimation
%       hop:        hop size used in pitch estimation
%   OUTPUT:
%       midi_mat_aligned:   matrix that contains the score notes aligned 
%                           with the student performance
%       notes_altered:      notes in the score that were split to account
%                           for silences
%       dtw_cost:           alignment cost
%       path:               path of alignment



midi_mat = readmidi(midi_path);

%make first onset 0, and propagate the change in onset times
%in order to make the score start from time 0
first_onset = midi_mat(1, 6);
midi_mat(:,6) = midi_mat(:,6) - first_onset;
midi_mat(1,6) = 1e-6; %0s in MIDI are handled weirdly


%normalize midi time to multiples of shortest note
%Rounding after multiplying by 2 to take into account dotted notes as well
shortest_note = min(midi_mat(:,2));
midi_mat(:,2) = midi_mat(:,2)./shortest_note;
midi_mat(:,2) = round(midi_mat(:,2)*2)/2;

%compensate for the pitch offset
%process in cents rather than hertz
wav_pitch_contour_in_midi = 69+12*log2(f0_wav/440);
wav_pitch_contour_in_midi(wav_pitch_contour_in_midi == -Inf) = 0;

%remove zeros from pitch contour
lead_trail_z = find(wav_pitch_contour_in_midi ~= 0);
wav_pitch_contour_in_midi = wav_pitch_contour_in_midi(lead_trail_z(1):lead_trail_z(end));

zeros_other = find(wav_pitch_contour_in_midi == 0);
%not zeros
notzeros = find(wav_pitch_contour_in_midi ~= 0); %mapping function
wav_pitch_contour_in_midi(zeros_other) = [];

% perform alignment
% [~, ix, iy] = dtw(midi_mat(:,4), wav_pitch_contour_in_midi);
D = wrappedDist(midi_mat(:,4), wav_pitch_contour_in_midi, 12);
[path, C] = ToolSimpleDtw(D);
%reconstruct the alignment
path(:, 2) = notzeros(path(:, 2));

posi = diff(path(:, 1));
posi = [0; posi];
newpath = path(posi > 0, :);
newpath = [1, 1; newpath];
newpath(:, 1) = midi_mat(newpath(:, 1), 6);
newpath(:, 1) = newpath(:, 1)./newpath(end,1);
newpath(:, 2) = newpath(:, 2)./newpath(end,2);

dtw_cost = C(end,end);
dtw_cost = dtw_cost/length(path);

end

function midi_mat = addSilence(midi_mat, previous_note, hop, fs_w)
    for i = previous_note + 1:size(midi_mat,1)
        midi_mat(i,6) = midi_mat(i,6) + hop/fs_w; %add one frame of silence
    end
end

function [midi_mat, split_note] = splitNote(midi_mat, previous_note, pos, hop, fs_w)
    split_note = [];
    onset_time = midi_mat(previous_note,6);
    duration = midi_mat(previous_note, 7);
    
    onset_note_1 = onset_time;
    duration_note_1 = (pos)*hop/fs_w - onset_time;

    onset_note_2 = (pos)*hop/fs_w;
    duration_note_2 = onset_time+duration - (pos)*hop/fs_w;

    note_1 = [onset_note_1, duration_note_1, midi_mat(previous_note, 3:5), onset_note_1, duration_note_1];
    note_2 = [onset_note_2, duration_note_2, midi_mat(previous_note, 3:5), onset_note_2, duration_note_2]; 
    % check if silence is at note off or during note to split
    if(((pos-1)*hop/fs_w - onset_time >= duration) || (duration_note_2 <= 1e-6))
        midi_mat = addSilence(midi_mat, previous_note, hop, fs_w);
    else
        if(duration_note_1 <= 1e-6) %note was not played yet
%             midi_mat(previous_note,7) = duration_note_1;
            midi_mat = [midi_mat(1:previous_note-1,:); note_2; midi_mat(previous_note+1:end,:)];
            midi_mat = addSilence(midi_mat, previous_note - 1, hop, fs_w);
        else %split note
            split_note = previous_note;
            midi_mat = [midi_mat(1:previous_note-1,:); note_1; note_2; midi_mat(previous_note+1:end,:)];
            midi_mat = addSilence(midi_mat, previous_note, hop, fs_w);
        end
    end
end