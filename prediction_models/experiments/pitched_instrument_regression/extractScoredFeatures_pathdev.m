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
scorePath = [root_path '..' slashtype '..' slashtype 'FBA' YEAR_OPTION slashtype 'midiscores' slashtype 'Alto Sax' slashtype 'Middle School' slashtype  YEAR_OPTION 'middle_saxophone' '.mid'];
scoreMid = readmidi(scorePath);
[rwSc, clSc] = size(scoreMid);

[tf, flag] = findTuningFrequency(f0);
pitch_in_midi = 69+12*log2(f0/440);
pitch_in_midi(pitch_in_midi == -Inf) = 0;

pitch_in_midi(pitch_in_midi~=0) = pitch_in_midi(pitch_in_midi~=0) - (tf/100);
tfCompnstdF0 = pitch_in_midi;
tfCompnstdF0(tfCompnstdF0~=0) = (2.^((pitch_in_midi(tfCompnstdF0~=0)-69)/12))*440;

[dtw_cost, path] = alignScore_path(scorePath, tfCompnstdF0, audio, Fs, wSize, hop);

pathlen = size(path, 1);
window = floor(pathlen/4);
step = floor(pathlen/8);
for i = 0:6
    slp_m = slope_mean(path(i*step+1:i*step+window, :));
    features(1, i+1) = slp_m;
end
features(1, 8) = slope_mean(path);

end