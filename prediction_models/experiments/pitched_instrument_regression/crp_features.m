function crp_value = crp_features(midi_path, f0_wav)
%¡¾¡¿¡¾¡¿¡¾¡¿

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
nn = transcript(wav_pitch_contour_in_midi, 0.3);

crp_value = size(nn, 2) - size(midi_mat, 1);
p = 1;

