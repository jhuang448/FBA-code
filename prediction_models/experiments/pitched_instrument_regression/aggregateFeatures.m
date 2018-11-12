function new_features = aggregateFeatures(features, flg)
features = features(features~=Inf);
num = size(features, 2);
f = features;
new_features = [max(f, [], 2) min(f, [], 2) mean(f, 2) var(f, 0, 2)];
if flg == 1
    f1 = diff(f,1,2);
    new_features = [new_features max(f1, [], 2) min(f1, [], 2) mean(abs(f1), 2) var(f1, 0, 2)];
end