load('data/middleAlto Saxophone5_Score_2013.mat', 'student_idx');
load('predictions/Score_fixedrevDTW_453.mat');
pdt1 = pdt;
diff1 = abs(pdt1-test_labels);
labels = test_labels;
load('predictions/Score_alignLength_453.mat');
pdt2 = pdt;
diff2 = abs(pdt2-test_labels);
[B,I] = sort(abs(diff1-diff2));

% year: ID      groundtruth     pdt1    pdt2
% 2015 idx [116 24 89]
% 2015: 57623   0.7             0.62    0.41
% 2015: 52380   0.8             0.70    0.54
% 2015: 55392   0.6             0.59    0.38
% 2014 idx [138 77 108]
% 2014: 46225   0.5             0.81    1.19
% 2014: 41836   0.3             0.31    0.60
% 2014: 43468   0.2             0.16    0.60
% 2013 idx [51 117 69]
% 2013: 31142   0.8             0.70    0.52
% 2013: 35513   0.4             0.39    0.22
% 2013: 32059   0.4             0.73    0.57

