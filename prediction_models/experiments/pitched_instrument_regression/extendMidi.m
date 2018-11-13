function [extend_midi, map] = extendMidi(midi_mat)
midi_mat(:, 2) = midi_mat(:, 2).*2;
extend_midi = zeros(1, sum(midi_mat(:, 2)));
p = 1;
map = zeros(1, size(midi_mat, 1));
for i = 1:size(midi_mat, 1)
    map(i) = p;
    extend_midi(p:p+midi_mat(i, 2)-1) = midi_mat(i, 4) * ones(1, midi_mat(i, 2));
    p = p + midi_mat(i, 2);
end