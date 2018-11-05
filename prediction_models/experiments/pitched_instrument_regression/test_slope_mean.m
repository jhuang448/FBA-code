path = 'F:\FBA2013-pYin-experiments\FBA2013-pYin-experiments\src\prediction_models\experiments\pitched_instrument_regression\data\';
filename = 'middleAlto Saxophone5_Score_pathmean_2014final';
load([path filename]);

num = size(features, 1);

for i=1:num
    %plot(1:7, features(i, 1:7), '-or');
    %axis([0 8 0.5 1.5]);
end
tmpdiff = diff(features(:, 1:7), 1, 2);
t = mean(abs(tmpdiff), 2)./max(abs(tmpdiff),[],2);
[Rsq, S, p, r] = myRegEvaluation(labels(:, 4).*labels(:, 3), t);

fprintf(['\nResults complete.\nR squared: ' num2str(Rsq) ...
         '\nStandard error: ' num2str(S) '\nP value: ' num2str(p) ...
         '\nCorrelation coefficient: ' num2str(r) '\n']);