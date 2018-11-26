% expanded midi: middleAlto Saxophone5_Score_alignLength_2013.mat
% modified: middleAlto Saxophone5_Score_fixedrevDTW_2013.mat

I = cell(3,1);

for i=2013:2015
    load('middleAlto Saxophone5_Score_fixedrevDTW_' + string(i) + '.mat')
    features_m = features;
    load('middleAlto Saxophone5_Score_alignLength_' + string(i) + '.mat')
    features_ex = features;
    
    % normalized within the year
    [features_m, ~] = NormalizeFeatures(features_m, zeros(1,23));
    [features_ex, ~] = NormalizeFeatures(features_ex, zeros(1,23));
    
    load('middleAlto Saxophone5_Score_' + string(i) + '.mat', 'student_idx');

    clear features;

    diff = abs(features_m - features_ex);
    sum_diff = sum(diff, 2);
    [B, I_] = sort(sum_diff);
    I{i-2012}{1} = [I_ B];
    I{i-2012}{2} = student_idx(I_, :);
    
    sum_feature_diff = sum(diff, 1)/size(features_m, 1);
    I{i-2012}{3} = sum_feature_diff;
end

% features:
bar(1:23, I{1}{3}+I{2}{3}+I{3}{3});