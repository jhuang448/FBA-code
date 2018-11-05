function new_features = aggregateFeatures(features)
num = size(features, 2);
f = features(:, 1:7);
new_features = [max(f, [], 2) min(f, [], 2) mean(f, 2) var(f, 0, 2)];
f1 = diff(f,1,2);
new_features = [new_features max(f1, [], 2) min(f1, [], 2) mean(abs(f1), 2) var(f1, 0, 2)];