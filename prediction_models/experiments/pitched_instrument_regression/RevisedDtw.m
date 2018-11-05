% ======================================================================
%> @brief computes path through a distance matrix with simple Dynamic Time
%> Warping
%>
%> @param D: distance matrix
%>
%> @retval p path with matrix indices
%> @retval C cost matrix
% ======================================================================
function [p, C, jump] = RevisedDtw(D, idx)
 
    % cost initialization
    C               = zeros(size(D));
    C(1,:)          = cumsum(D(1,:));
    C(:,1)          = cumsum(D(:,1));
    % traceback initialization
    DeltaP          = zeros(size(D));
    DeltaP(1,2:end) = 3; % (0,-1)
    DeltaP(2:end,1) = 2; % (-1,0)
    
    penalty = mean(D(:))*5;
    flag = 0;
    
    % recursion
    for (n_A = 2:size(D,1))
        if (isempty(find(idx == n_A)))
            flag = 0;
        else
            flag = 1;
        end
        for (n_B = 2:size(D,2))
            % find preceding min (diag, column, row)
            if (flag == 1 && n_B < size(D,2)-2) %¡¾¡¿
                [fC_min, DeltaP(n_A,n_B)]   = min([C(n_A-1,n_B-1), C(n_A-1,n_B), C(n_A,n_B-1), C(n_A-1, n_B+1)+penalty, C(n_A-1, n_B+2)+penalty]);
            else
                [fC_min, DeltaP(n_A,n_B)]   = min([C(n_A-1,n_B-1), C(n_A-1,n_B), C(n_A,n_B-1)]);
            end
            C(n_A, n_B)                 = D(n_A,n_B) + fC_min;
        end
    end

    jump = 0;
    
    % traceback
    iDec= [-1 -1; -1 0; 0 -1; -1 1; -1 2; -1 3; -1 4]; % compare DeltaP contents: diag, vert, hori
    p   = size(D);  % start with the last element
    n   = [size(D,1), size(D,2)]; %[n_A, n_B];
    while ((n(1) > 1) || (n(2) > 1))
        n = n + iDec(DeltaP(n(1),n(2)),:);
        jump = jump + (DeltaP(n(1),n(2)) >= 4); %compute number of jumps
        % update path (final length unknown)
        p   = [n; p];
    end   
end