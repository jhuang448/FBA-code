c = categorical({'Musicality', 'Note Accuracy', 'Rhythmic Accuracy', 'Tone Quality'});
i = 1;

Rsq345 = [[Rsq_r345c001(1,i),Rsq_r345c01(1,i),Rsq_r345c1(1,i),Rsq_r345c10(1,i),Rsq_r345c100(1,i)];
[Rsq_r345c001(2,i),Rsq_r345c01(2,i),Rsq_r345c1(2,i),Rsq_r345c10(2,i),Rsq_r345c100(2,i)];
[Rsq_r345c001(3,i),Rsq_r345c01(3,i),Rsq_r345c1(3,i),Rsq_r345c10(3,i),Rsq_r345c100(3,i)];
[Rsq_r345c001(4,i),Rsq_r345c01(4,i),Rsq_r345c1(4,i),Rsq_r345c10(4,i),Rsq_r345c100(4,i)];];
bar(c, Rsq345);
legend('c=0.01', 'c=0.1', 'c=1', 'c=10', 'c=100');

Rsq354 = [[Rsq_r354c001(1,i),Rsq_r354c01(1,i),Rsq_r354c1(1,i),Rsq_r354c10(1,i),Rsq_r354c100(1,i)];
[Rsq_r354c001(2,i),Rsq_r354c01(2,i),Rsq_r354c1(2,i),Rsq_r354c10(2,i),Rsq_r354c100(2,i)];
[Rsq_r354c001(3,i),Rsq_r354c01(3,i),Rsq_r354c1(3,i),Rsq_r354c10(3,i),Rsq_r354c100(3,i)];
[Rsq_r354c001(4,i),Rsq_r354c01(4,i),Rsq_r354c1(4,i),Rsq_r354c10(4,i),Rsq_r354c100(4,i)];];
bar(c, Rsq354);
legend('c=0.01', 'c=0.1', 'c=1', 'c=10', 'c=100');

Rsq453 = [[Rsq_r453c001(1,i),Rsq_r453c01(1,i),Rsq_r453c1(1,i),Rsq_r453c10(1,i),Rsq_r453c100(1,i)];
[Rsq_r453c001(2,i),Rsq_r453c01(2,i),Rsq_r453c1(2,i),Rsq_r453c10(2,i),Rsq_r453c100(2,i)];
[Rsq_r453c001(3,i),Rsq_r453c01(3,i),Rsq_r453c1(3,i),Rsq_r453c10(3,i),Rsq_r453c100(3,i)];
[Rsq_r453c001(4,i),Rsq_r453c01(4,i),Rsq_r453c1(4,i),Rsq_r453c10(4,i),Rsq_r453c100(4,i)];];
bar(c, Rsq453);
legend('c=0.01', 'c=0.1', 'c=1', 'c=10', 'c=100');
