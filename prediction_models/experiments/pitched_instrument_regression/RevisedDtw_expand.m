% ======================================================================
%> @brief computes path through a distance matrix with simple Dynamic Time
%> Warping
%>
%> @param D: distance matrix
%>
%> @retval p path with matrix indices
%> @retval C cost matrix
% ======================================================================
function [p, C, jump] = RevisedDtw_expand(D, idx, map)
 
    % cost initialization
    C               = zeros(size(D));
    C(1,:)          = cumsum(D(1,:));
    C(:,1)          = cumsum(D(:,1));
    % traceback initialization
    DeltaP          = zeros(size(D));
    DeltaP(1,2:end) = 3; % (0,-1)
    DeltaP(2:end,1) = 2; % (-1,0)
    
    % penalty for jumping
    penalty = mean(D(:))*5;
    % flag: if allow jump
    flag = 0;
    flag2 = 0;
    % step: the two possible jump positions
    step1 = 0;
    step2 = 0;
    
    % recursion
    for (n_A = 2:size(D,1))
        if (isempty(find(idx == n_A)))
            flag = 0;
        else
            flag = 1;
        end
        for (n_B = 2:size(D,2))
            % find preceding min (diag, column, row)
            
            if (isempty(find(map == n_B)) || find(map==n_B) >= size(map, 2)-3)
                flag2 = 0;
            else % compute the jump position
                flag2 = 1;
                nBp = find(map == n_B);
                step1 = map(nBp+1);
                step2 = map(nBp+2);
                step3 = map(nBp+3);
                step4 = map(nBp+4);
            end
            % no continual jumps
            if (flag == 1 && flag2 == 1 && max([DeltaP(n_A-1, step1), DeltaP(n_A-1, step2)]) < 4) %¡¾¡¿
                [fC_min, DeltaP(n_A,n_B)]   = min([C(n_A-1,n_B-1), C(n_A-1,n_B), C(n_A,n_B-1), C(n_A-1, step1)+penalty, C(n_A-1, step2)+penalty]);
            else
                [fC_min, DeltaP(n_A,n_B)]   = min([C(n_A-1,n_B-1), C(n_A-1,n_B), C(n_A,n_B-1)]);
            end
            C(n_A, n_B)                 = D(n_A,n_B) + fC_min;
        end
    end

    jump = 0;
    
    % traceback
    iDec= [-1 -1; -1 0; 0 -1]; % compare DeltaP contents: diag, vert, hori
    p   = size(D);  % start with the last element
    n   = [size(D,1), size(D,2)]; %[n_A, n_B];
    while ((n(1) > 1) || (n(2) > 1))
        if (DeltaP(n(1), n(2)) <= 3)
            n = n + iDec(DeltaP(n(1),n(2)),:);
        else
            jump = jump + 1;
            nBp = find(map == n(2));
            step1 = map(nBp+1);
            step2 = map(nBp+2);
            n(1) = n(1) -1;
            if (DeltaP(n(1), n(2)) == 4)
                n(2) = step1;
            else
                n(2) = step2;
            end
        end
        %compute number of jumps
        % update path (final length unknown)
        p   = [n; p];
    end   
end