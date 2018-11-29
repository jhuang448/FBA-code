%% Evaluate Regression for Pitched Instrument 
% CL@GTCMT 2015
% evaluatePerformancePitchedInstrument(read_file_name)
% objective: Evaluate regression model for pitched instrument experiment.
%
% read_file_name: string, name of file to read training data from.

function evaluatePerformancePitchedInstrument2_1(read_file_name1, read_file_name2, test_file_name, flag)
%DATA_PATH = '../../../../FBA2013data/';%¡¾¡¿
DATA_PATH = 'experiments/pitched_instrument_regression/data/';

%flag: whether to combine features
%flag = 0;%set flag to 0: not combining features
cmbf1 = ['middleAlto Saxophone5_Score_fixedrevDTW_' read_file_name1(end-3:end)];
cmbf2 = ['middleAlto Saxophone5_Score_fixedrevDTW_' read_file_name2(end-3:end)];
cmbf3 = ['middleAlto Saxophone5_Score_fixedrevDTW_' test_file_name(end-3:end)];

%cmbf21 = 'middleAlto Saxophone5_Score_pause_2013';
%cmbf22 = 'middleAlto Saxophone5_Score_pause_2014';
%cmbf23 = 'middleAlto Saxophone5_Score_pause_2015';

% Check for existence of file with training data features and labels.
if(exist('read_file_name1', 'var') && exist('read_file_name2', 'var'))
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end
else
  error('No file name specified.');
end

% Load training data.
load([full_data_path read_file_name1]);
features1 = features;
llb = size(labels, 2);
labels1 = labels(:, llb-3:llb);
%idx1 = student_idx;
if flag == 1
    load([full_data_path cmbf1]);
    
    if cmbf1(end) == '3' && cmbf1(23) == 'N'
        features1(6, :) = [];
        labels1(6, :) = [];
    end
    
    assert(size(features1, 1) == size(features, 1));
    features1 = [features1, features];
    
    %load([full_data_path cmbf21]);
    %assert(size(features1, 1) == size(features, 1));
    %features1 = [features1, features];
end
load([full_data_path read_file_name2]);
features2 = features;
llb = size(labels, 2);
labels2 = labels(:, llb-3:llb);
if flag == 1
    load([full_data_path cmbf2]);
    
    if cmbf2(end) == '3' && cmbf2(23) == 'N'
        features2(6, :) = [];
        labels2(6, :) = [];
    end
    
    assert(size(features2, 1) == size(features, 1));
    features2 = [features2, features];
    
    %load([full_data_path cmbf22]);
    %assert(size(features2, 1) == size(features, 1));
    %features2 = [features2, features];
end
train_features = [features1; features2];
train_labels = [labels1; labels2];
%idx2 = student_idx;

load([full_data_path test_file_name]);
test_features = features;
llb = size(labels, 2);
test_labels = labels(:, llb-3:llb);
%idx3 = student_idx;
if flag == 1
    load([full_data_path cmbf3]);
    
    if cmbf3(end) == '3' && cmbf3(23) == 'N'
        test_features(6, :) = [];
        test_labels(6, :) = [];
    end
    
    assert(size(test_features, 1) == size(features, 1));
    test_features = [test_features, features];
    
    %load([full_data_path cmbf23]);
    %assert(size(test_features, 1) == size(features, 1));
    %test_features = [test_features, features];
end

%
%train_features = train_features(:, 2:13);
%test_features = test_features(:, 2:13);
%if test_file_name(23) == 'N'
%    train_features(:, 25:32) = aggregateFeatures(train_features(:, 25:32));%¡¾¡¿¡¾¡¿¡¾¡¿
%    test_features(:, 25:32) = aggregateFeatures(test_features(:, 25:32));
%else
%    train_features(:, 23:30) = aggregateFeatures(train_features(:, 23:30));%¡¾¡¿¡¾¡¿¡¾¡¿
%    test_features(:, 23:30) = aggregateFeatures(test_features(:, 23:30));
%end
%¡¾¡¿
%train_features(:, 32) = abs(train_features(:, 32) - train_features(:, 31));
%test_features(:, 32) = abs(test_features(:, 32) - test_features(:, 31));
%train_features(:, 33:34) = abs(train_features(:, 33:34));
%test_features(:, 33:34) = abs(test_features(:, 33:34));
%train_features(:, 34) = log(train_features(:, 34)+1);
%test_features(:, 34) = log(test_features(:, 34)+1);

train_features = train_features(:, [1:23]);
test_features = test_features(:, [1:23]);

[train_features, test_features] = NormalizeFeatures(train_features, test_features);

pdt = [];
Rsq_r = [];
for i = 1:4
    %i = 2;
    % Train the classifier and get predictions for the current fold.
    svm = svmtrain(train_labels(:, i), train_features, '-s 4 -t 0 -q');
    predictions = svmpredict(test_labels(:, i), test_features, svm, '-q');
    pdt = [pdt predictions];
    %predictions = round(predictions.*10)./10; % quantization
    [Rsq, S, p, r] = myRegEvaluation(test_labels(:, i), predictions);
    Rsq_r = [Rsq_r; [Rsq, r]]; %save for svm parameter tuning
    
    fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
             '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
             '\nCorrelation coefficient: ' num2str(r) '\n']);
end
%q_pdt = round(pdt.*10)./10;
%save(['predictions/Score_alignLength_453'], 'pdt', 'test_labels');
end

