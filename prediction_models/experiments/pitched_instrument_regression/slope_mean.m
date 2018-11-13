function av_slope = slope_mean(path, bg, ed)
% Computes the deviation from the average slope of a given path
bg_slope = bg;
ed_slope = ed;
while(bg_slope > 1 && bg_slope == bg)
    bg_slope = bg_slope - 1;
end
while(ed_slope < size(path, 1) && ed_slope == ed)
    ed_slope = ed_slope + 1;
end
av_slope = (path(ed_slope, 2) - path(bg_slope,2))/(path(ed_slope,1) - path(bg_slope,1));