%% Scan segments
% CW@GTCMT 2015
% objective: scan for segment info
% segments = scanSegments(segment_option, student_ids)
% segment_option = m*1 int vector, specify your target segments, ex: [3; 5]
% student_ids = N*1 int vector of student ids
% segments = N*1 cell vector, each cell is a m*2 matrix,
%            1st column = starting time, 2nd column is duration
% year_option = string mentioning the year for which segments are to be
% scanned

function segments = scanSegments(segment_option, student_ids, year_option, band_option)%����band_option
root_path = deriveRootPath();

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end
    % //initialization 
annPath = [root_path '..' slashtype '..' slashtype 'FBA' year_option];
N = length(student_ids);
segments = cell(N, 1);

%for i = 1:3
if (band_option == 'middle')
    i = 2;
elseif (band_option == 'symphonic')
    i = 3;
elseif (band_option == 'concert')
    i == 1;
end

    if year_option == '2013'
        switch i
            case 1
                bandFolder = [slashtype 'concertbandscores'];
            case 2
                bandFolder = [slashtype 'middleschoolscores'];
            case 3
                bandFolder = [slashtype 'symphonicbandscores'];
        end
    else
        switch i
            case 1
                bandFolder = [slashtype 'concertband'];
            case 2
                bandFolder = [slashtype 'middleschool'];
            case 3
                bandFolder = [slashtype 'symphonicband'];
        end
    end
    
    for j = 1:N
        % //create file path
        current_id = num2str(student_ids(j));
        file_name  = strcat(slashtype, current_id, '_', 'segment.txt'); 
        filePath   = strcat(annPath, bandFolder, slashtype, current_id, file_name);
        
        % //read segment file
        if exist(filePath, 'file') == 2
            [start, duration] = textread(filePath,'%f %f','headerlines',1);
            if (size(start,1) >= 5)%��������
                segments{j,1} = [start(segment_option), duration(segment_option)];
            end
        else
        end
       
    end 
%end

 
