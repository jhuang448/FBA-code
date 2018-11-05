function [Q res] = calcQ(X);
%   calculate matrix Q (RQA-diagonal lines) for a CRP
%   Serra-Joan-PhD-Thesis-2011 page 60

[nrow ncol] = size(X);
Q = zeros(nrow, ncol);

for iter = 1:nrow
    Q(iter,1) = 0;
    Q(iter,2) = 0;
end

for iter = 1:ncol
    Q(nrow-1,iter) = 0;
    Q(nrow,iter) = 0;
end

for iter1=(nrow-2):(-1):1
    for iter2 = 3:ncol
        if X(iter1, iter2)==0
            Q(iter1, iter2) = max([Q(iter1+1,iter2-1) Q(iter1+2,iter2-1) Q(iter1+1,iter2-2)])+1;
        else
            Q(iter1, iter2) = max([0 Q(iter1+1,iter2-1)-pnt(X(iter1+1,iter2-1)) Q(iter1+2,iter2-1)-pnt(X(iter1+2,iter2-1)) Q(iter1+1,iter2-2)-pnt(X(iter1+1,iter2-2))]);
        end
    end
end

res = max(max(Q));

function pnt_val = pnt(no);
%   penalty for a disruption onset(no = 0) or penalty for a disruption
%   extention(no = 1);

if no == 0
    pnt_val = 3;
else
    pnt_val = 7;
end

