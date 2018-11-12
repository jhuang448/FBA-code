% pdt: predictions for one year
test_labels = pdt_a;% use prediction

l = size(pdt, 1);

m = zeros(31, 4);

for i=0:30
    idx = (features(:, 23) == i);
    if sum(idx) > 0
        m(i+1, :) = mean(test_labels(idx, :), 1);
    end
end
yyaxis left
edges = [0:1:30];
histogram(features(:, 23), [-0.5:1:24.5]);
hold on;
yyaxis right
t = m(:, 1)>0;
plot(edges(t), m(t,1), '-r*');
plot(edges(t), m(t,2), '-b*');
plot(edges(t), m(t,3), '-c*');
plot(edges(t), m(t,4), '-m*');
ylim([0,1]);
legend('jumps', 'musicality', 'note', 'rhythmic', 'tone');
title('jumps and mean values of predictions - 3 years');