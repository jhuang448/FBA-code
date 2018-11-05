load('E:\SEM1\FBA\dataAnalysis\middle_saxophone_21_15.mat');
plot(test_labels(:, 2), '-*r');hold on;
plot(pdt(:, 2), '-*b');
plot(q_pdt(:, 2), '-*g');
legend('ground truth', 'predictions', 'quantized predictions');