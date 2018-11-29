wavPath = 'F:/FBA2013experiments/FBA2013experiments/src/midiGeneration/converted/';
midiPath = 'F:/FBA2013experiments/FBA2013experiments/src/midiGeneration/generated/';
% origPath... not used

% get the file list
listing = dir(wavPath);
l = size(listing, 1);
nameList = [];
for i = 3:l
    nameList = [nameList; listing(i).name(1:end-4)];
end
clear listing;

scoreFolder = 'F:/FBA2013experiments/FBA2013experiments/src/midiGeneration/original/';

hop = 256;
wSize = 1024;
Resample_fs = 44100;

jump_detected = zeros(1, l-2);
% for every file compute the aligned-midi
% compute the difference between it and the true midi contour
for i = 11:l-2
    i
    [audio, Fs] = audioread('F:/2014_orig.wav');%wavPath + string(nameList(i, :)) + '.wav');
    YEAR_OPTION = nameList(i, 1:4);
    scorePath = scoreFolder + string(YEAR_OPTION) + 'middle_saxophone.mid';
    
    % resample audio
    audio = resample(audio,Resample_fs,Fs);
    
    % Normalize audio;
    normalized_audio = mean(audio, 2);
    normalized_audio = normalized_audio ./ max(abs(normalized_audio));
    
    % compute pitch contour of audio
    algo='acf';
    [f0, ~] = estimatePitch(normalized_audio, Fs, hop, wSize, algo);
    [tf, flag] = findTuningFrequency(f0);
    pitch_in_midi = 69+12*log2(f0/440);
    pitch_in_midi(pitch_in_midi == -Inf) = 0;
    pitch_in_midi2 = pitch_in_midi;

    pitch_in_midi(pitch_in_midi~=0) = pitch_in_midi(pitch_in_midi~=0) - (tf/100);
    tfCompnstdF0 = pitch_in_midi;
    tfCompnstdF0(tfCompnstdF0~=0) = (2.^((pitch_in_midi(tfCompnstdF0~=0)-69)/12))*440;
    
    % get path
    [algndmidi, note_altrd, dtw_cost, path, jump] = alignScore_expandDTW(scorePath, tfCompnstdF0, normalized_audio, Fs, wSize, hop);
    
    gtmidi = readmidi('F:/2014midi.mid');%midiPath + string(nameList(i, :)) + '.mid');
    
    len = floor((gtmidi(end, 6) + gtmidi(end, 7)) * Fs / hop);
    path_contour = buildContour_midi(algndmidi, Fs, hop, len);
    gt_contour = buildContour_midi(gtmidi, Fs, hop, len);
    
    jump_detected(i) = jump;
    
    wav_pitch_contour = toPitchContour(tfCompnstdF0);
    
    subplot(2,1,1);
    plot(wav_pitch_contour);
    legend('pitch contour');
    subplot(2,1,2);
    plot(1:len, gt_contour, '-r');
    hold on;
    plot(1:len, path_contour, '-b');
    legend('ground truth','aligned midi');
    hold off;
end

function m1 = buildContour(path)
len = path(end, 2);
m1 = zeros(1, len);
m1(path(:, 2)) = midi_mat(path(:, 1), 4);
end

function m2 = buildContour_midi(midimat, fs, hop, len)
m2 = zeros(1, len);
note_num = size(midimat, 1);
for i=1:note_num
    st = floor(midimat(i, 6)*fs/hop);
    ed = floor((midimat(i, 6)+midimat(i, 7))*fs/hop);
    if st == 0
        st = 1;
    end
    if ed > len
        assert(i == note_num);
        ed = len;
    end
    assert(ed >= st);
    m2(st:ed) = midimat(i, 4);
end

end

function wav_pitch_contour_in_midi = toPitchContour(f0_wav)
wav_pitch_contour_in_midi = 69+12*log2(f0_wav/440);
wav_pitch_contour_in_midi(wav_pitch_contour_in_midi == -Inf) = 0;

%remove zeros from pitch contour
lead_trail_z = find(wav_pitch_contour_in_midi ~= 0);
wav_pitch_contour_in_midi = wav_pitch_contour_in_midi(lead_trail_z(1):lead_trail_z(end));

zeros_other = find(wav_pitch_contour_in_midi == 0);

%wav_pitch_contour_in_midi(zeros_other) = [];

end
