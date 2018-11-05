function CRP_X = calcCRP(S1, S2);
%   CRP between S1 and S2, using Euclidean Distance

CRP_X = dist(S1, S2');
th = median(CRP_X(:));
CRP_X = (CRP_X <= th);
CRP_X = flipud(CRP_X);
   imshow(CRP_X, [])
