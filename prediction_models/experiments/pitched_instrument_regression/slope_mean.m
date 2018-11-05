function av_slope = slope_mean(path)
% Computes the deviation from the average slope of a given path
av_slope = (path(end, 2) - path(1,2))/(path(end,1) - path(1,1));