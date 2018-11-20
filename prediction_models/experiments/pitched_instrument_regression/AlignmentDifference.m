function diffMtx = AlignmentDifference(audio, Fs, wSize, hop, YEAR_OPTION, NUM_FEATURES)
slashtype = '/';
root_path = deriveRootPath();
scorePath = [root_path '..' slashtype '..' slashtype 'FBA' YEAR_OPTION slashtype 'midiscores' slashtype 'Alto Sax' slashtype 'Middle School' slashtype YEAR_OPTION 'middle_saxophone.mid'];
midi_mat = readmidi(scorePath);

[path1, wav_pitch_contour_in_midi] = getPath(audio, Fs, wSize, hop, YEAR_OPTION, NUM_FEATURES, 1);
[path2, ~] = getPath(audio, Fs, wSize, hop, YEAR_OPTION, NUM_FEATURES, 2);
[path3, ~] = getPath(audio, Fs, wSize, hop, YEAR_OPTION, NUM_FEATURES, 3);

len = size(wav_pitch_contour_in_midi, 2);
m1 = zeros(1, len);
m2 = zeros(1, len);
m3 = zeros(1, len);

m1(path1(:, 2)) = midi_mat(path1(:, 1), 4);
m2(path2(:, 2)) = midi_mat(path2(:, 1), 4);
m3(path3(:, 2)) = midi_mat(path3(:, 1), 4);


m3(path3(end, 2):end) = midi_mat(path3(end, 1), 4);

%plot(wav_pitch_contour_in_midi, '-b');
%hold on;
%plot(m1, '-r');
%plot(m2, '-g');
%plot(m3, '-m');

diffMtx = zeros(1, 4);
diffMtx(1) = sum(abs(m1-m2));
diffMtx(2) = sum(abs(m2-m3));
diffMtx(3) = sum(abs(m1-m3));
diffMtx(4) = len;
