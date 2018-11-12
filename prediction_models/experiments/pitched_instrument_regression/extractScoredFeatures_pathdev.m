%% Feature vector creation
% AV@GTCMT
% [features] = extractScoredFeatures(audio, Fs, wSize, hop)
% objective: Create a feature vector of all the non score based features called inside this
% function
%
% INPUTS
% audio: samples
% Fs: sampling frequency
% wSize: window size in samples
% hop: hop in samples
%
% OUTPUTS
% features: 1 x N feature vector (where N is the number of features getting extracted in the function)
%¡¾¡¿
function [features] = extractScoredFeatures_pathdev(audio, Fs, wSize, hop, YEAR_OPTION, NUM_FEATURES)

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

[slopedev, ~] = slopeDeviation(path);
%[rwStu, clStu] = size(algndmidi);

pathlen = size(path, 1);
path(:, 1) = path(:, 1)./path(end,1);
path(:, 2) = path(:, 2)./path(end,2);
window = floor(3/(hop/Fs));
step = floor(window/2);
windowNum = floor((pathlen-window+step)/step);
slp_m = zeros(1, windowNum);
%slp_d = zeros(1, windowNum);
for i = 0:windowNum-1
    slp_m(i+1) = slope_mean(path(i*step+1:i*step+window, :));
    %[slp_d, ~] = slopeDeviation(path(:, i*step+1:i*step+window));
end
features(1, 1:8) = aggregateFeatures(slp_m, 1);
%features(1, 9:12) = aggregateFeatures(slp_d, 0);
end