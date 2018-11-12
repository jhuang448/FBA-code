load('data/14_40484alignment.mat');
%tfCompnstdF0 = medfilt1(tfCompnstdF0);
[algndmidi, note_altrd, dtw_cost, path, jump] = alignScore_revDTW(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);

%distance matrix
D2 = imresize(D./max(max(D)), [1000, 1000]);
imshow(D2);
hold on;
plot(path(:, 2)*1000/size(D, 2),path(:, 1)*1000/size(D, 1),  'r');

%
plot(wav_pitch_contour_in_midi);
hold on;
plot(path(:, 2), midi_mat(path(:, 1), 4));

orig_f0 = zeros(1, size(f0_wav, 2));
orig_f0(lead_trail_z) = wav_pitch_contour_in_midi;
orig_midi = zeros(1, size(f0_wav, 2));
orig_midi(lead_trail_z) = midi_mat(path(:, 1), 4);
plot(orig_f0);
hold on;
plot(orig_midi);




