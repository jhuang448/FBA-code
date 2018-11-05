load('data/14_39016alignment.mat')
[algndmidi, note_altrd, dtw_cost, path] = alignScore(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);