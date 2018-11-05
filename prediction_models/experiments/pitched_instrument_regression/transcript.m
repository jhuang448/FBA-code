function new_note = transcript(segment, threshold)
%分段/转谱
% 如果是两段拼起来的合并段，单独转谱后再接起，程序内只处理单独段

len = size(segment, 2);

cut = [1];
last_no = 1;
v = [];
for i =1:len-5
    if abs(segment(i+5)-segment(i)) > threshold || (segment(i+5) == 0 && segment(i) ~= 0)
        cut = [cut i+5];%在i+5处分割
        v = [v mean(segment(cut(last_no):cut(last_no+1)))];%计算平均音高
        if v(end) < 40
            v(end) = 0;
        end
        last_no = last_no + 1;%计数
    end
end
v = [v mean(segment(cut(last_no):len))];

%去掉过短的段落
len_of_note = [cut(2:last_no) len] - cut;
%返回new_note：第一行是Note的开始位置，第二行是音高，第三行是持续帧数
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

