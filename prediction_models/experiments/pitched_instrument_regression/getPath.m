function [expPath, wav_pitch_contour_in_midi] = getPath(audio, Fs, wSize, hop, YEAR_OPTION, NUM_FEATURES, DTW_No)
%DTW_No:
% 1: original dtw
% 2: modified dtw (allow jumps)
% 3: expanded midi, modified dtw
if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

features=zeros(1,NUM_FEATURES);
algo='acf';
timeStep = hop/Fs;

[f0, ~] = estimatePitch(audio, Fs, hop, wSize, algo);

% get the score to pass to the feature extraction function
root_path = deriveRootPath();
scorePath = [root_path '..' slashtype '..' slashtype 'FBA' YEAR_OPTION slashtype 'midiscores' slashtype 'Alto Sax' slashtype 'Middle School' slashtype YEAR_OPTION 'middle_saxophone.mid'];
scoreMid = readmidi(scorePath);
[rwSc, clSc] = size(scoreMid);

[tf, flag] = findTuningFrequency(f0);
pitch_in_midi = 69+12*log2(f0/440);
pitch_in_midi(pitch_in_midi == -Inf) = 0;
pitch_in_midi2 = pitch_in_midi;

pitch_in_midi(pitch_in_midi~=0) = pitch_in_midi(pitch_in_midi~=0) - (tf/100);
tfCompnstdF0 = pitch_in_midi;
tfCompnstdF0(tfCompnstdF0~=0) = (2.^((pitch_in_midi(tfCompnstdF0~=0)-69)/12))*440;

%¡¾¡¿MEDIAN FILTER HERE
%tfCompnstdF0 = medfilt1(tfCompnstdF0);
jump = 0;

% get F0 contour and midi_mat
f0_wav = tfCompnstdF0;
wav_pitch_contour_in_midi = 69+12*log2(f0_wav/440);
wav_pitch_contour_in_midi(wav_pitch_contour_in_midi == -Inf) = 0;

%remove zeros from pitch contour
lead_trail_z = find(wav_pitch_contour_in_midi ~= 0);
wav_pitch_contour_in_midi = wav_pitch_contour_in_midi(lead_trail_z(1):lead_trail_z(end));

zeros_other = find(wav_pitch_contour_in_midi == 0);
wav_pitch_contour_in_midi(zeros_other) = [];
midi_mat = readmidi(scorePath);

%---------------------------- original DTW
if DTW_No == 1
if flag == 1
    pitch_in_midi2(pitch_in_midi2~=0) = pitch_in_midi2(pitch_in_midi2~=0) + (tf/100);
    tfCompnstdF02 = pitch_in_midi2;
    tfCompnstdF02(tfCompnstdF02~=0) = (2.^((pitch_in_midi2(tfCompnstdF02~=0)-69)/12))*440;
    [algndmid1, note_onsets1, dtw_cost1, path1] = alignScore(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);
    [algndmid2, note_onsets2, dtw_cost2, path2] = alignScore(scorePath, tfCompnstdF02, audio, Fs, wSize, hop);
    if dtw_cost2 > dtw_cost1
       algndmidi = algndmid1;
       note_altrd = note_onsets1;
       dtw_cost = dtw_cost1;
       path = path1;
    else
       algndmidi = algndmid2;
       note_altrd = note_onsets2;
       dtw_cost = dtw_cost2;
       path = path2;
       tfCompnstdF0 = tfCompnstdF02;
    end
else%¡¾¡¿
    [algndmidi, note_altrd, dtw_cost, path] = alignScore(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);
end % change to alignScore_revDTW to allow jumps ¡¾¡¿
expPath = path;
end
%---------------------------- modified DTW
if DTW_No == 2
if flag == 1
    pitch_in_midi2(pitch_in_midi2~=0) = pitch_in_midi2(pitch_in_midi2~=0) + (tf/100);
    tfCompnstdF02 = pitch_in_midi2;
    tfCompnstdF02(tfCompnstdF02~=0) = (2.^((pitch_in_midi2(tfCompnstdF02~=0)-69)/12))*440;
    [algndmid1, note_onsets1, dtw_cost1, path1, jp1] = alignScore_revDTW(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);
    [algndmid2, note_onsets2, dtw_cost2, path2, jp2] = alignScore_revDTW(scorePath, tfCompnstdF02, audio, Fs, wSize, hop);
    if dtw_cost2 > dtw_cost1%¡¾¡ü¡¿
       algndmidi = algndmid1;
       note_altrd = note_onsets1;
       dtw_cost = dtw_cost1;
       path = path1;
       jump = jp1;%¡¾¡¿
    else
       algndmidi = algndmid2;
       note_altrd = note_onsets2;
       dtw_cost = dtw_cost2;
       path = path2;
       tfCompnstdF0 = tfCompnstdF02;
       jump = jp2;%¡¾¡¿
    end
else%¡¾¡¿
    [algndmidi, note_altrd, dtw_cost, path, jump] = alignScore_revDTW(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);
end % change to alignScore_revDTW to allow jumps ¡¾¡¿    
expPath = path;
end

%---------------------------- expanded midi alignment
if DTW_No == 3
    
if flag == 1
    pitch_in_midi2(pitch_in_midi2~=0) = pitch_in_midi2(pitch_in_midi2~=0) + (tf/100);
    tfCompnstdF02 = pitch_in_midi2;
    tfCompnstdF02(tfCompnstdF02~=0) = (2.^((pitch_in_midi2(tfCompnstdF02~=0)-69)/12))*440;
    [algndmid1, note_onsets1, dtw_cost1, path1, jp1] = alignScore_expandDTW(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);
    [algndmid2, note_onsets2, dtw_cost2, path2, jp2] = alignScore_expandDTW(scorePath, tfCompnstdF02, audio, Fs, wSize, hop);
    if dtw_cost2 > dtw_cost1%¡¾¡ü¡¿
       algndmidi = algndmid1;
       note_altrd = note_onsets1;
       dtw_cost = dtw_cost1;
       path = path1;
       jump = jp1;%¡¾¡¿
    else
       algndmidi = algndmid2;
       note_altrd = note_onsets2;
       dtw_cost = dtw_cost2;
       path = path2;
       tfCompnstdF0 = tfCompnstdF02;
       jump = jp2;%¡¾¡¿
    end
else%¡¾¡¿
    [algndmidi, note_altrd, dtw_cost, path, jump] = alignScore_expandDTW(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);
end % change to alignScore_revDTW to allow jumps ¡¾¡¿

expPath = buildPathForPlot(path);
end