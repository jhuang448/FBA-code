function new_note = transcript(segment, threshold)
%�ֶ�/ת��
% ���������ƴ�����ĺϲ��Σ�����ת�׺��ٽ��𣬳�����ֻ��������

len = size(segment, 2);

cut = [1];
last_no = 1;
v = [];
for i =1:len-5
    if abs(segment(i+5)-segment(i)) > threshold || (segment(i+5) == 0 && segment(i) ~= 0)
        cut = [cut i+5];%��i+5���ָ�
        v = [v mean(segment(cut(last_no):cut(last_no+1)))];%����ƽ������
        if v(end) < 40
            v(end) = 0;
        end
        last_no = last_no + 1;%����
    end
end
v = [v mean(segment(cut(last_no):len))];

%ȥ�����̵Ķ���
len_of_note = [cut(2:last_no) len] - cut;
%����new_note����һ����Note�Ŀ�ʼλ�ã��ڶ��������ߣ��������ǳ���֡��
new_note = [cut(len_of_note > 10); v(len_of_note > 10); len_of_note(len_of_note > 10)];

last_no = size(new_note, 2);

%plot
ln = zeros(1, len);
for i = 1:last_no
    ln(new_note(1, i):new_note(1, i)+new_note(3, i)) = new_note(2, i);
end
if last_no > 0
ln(new_note(1, last_no):len) = new_note(2, last_no);
end
subplot(2,1,2), plot(1:len, ln, '-r', 1:len, segment, '-b');

