tn = size(path, 1);

curIdx = path(1,1);
bg = 1;
ed = 1;
for i = 1:tn
    if (path(i, 1) == curIdx)
        continue;
    end
    ed = i-1;
    player = audioplayer(audio(Fs*bg:Fs*ed), Fs);
    play(player);
    bg = i;
    curIdx = path(i, 1);
end
    