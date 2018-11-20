% Objective: Store (score based) designed features for each student for the specified
% segment, year and instrument
% Inputs: 
% BAND_OPTION: band name i.e. concert band, middle school or
% symphonic band
% INSTRUMENT_OPTION: eg. alto sax, oboe
% SEGMENT_OPTION: eg. 1-5
% YEAR_OPTION: eg. 2013, 2014, 2015
% Output: Extracted features and labels get stored in 'data' folder with
% the name in variable write_file_name which includes the band option,
% instrument option and segment name

function getAlignmentDiff(BAND_OPTION, INSTRUMENT_OPTION, SEGMENT_OPTION, YEAR_OPTION, NUM_FEATURES)

if ismac
    % Code to run on Mac plaform
    slashtype='/';
elseif ispc
    % Code to run on Windows platform
    slashtype='\';
end

DATA_PATH = ['experiments' slashtype 'pitched_instrument_regression' slashtype 'data' slashtype];
write_file_name = [BAND_OPTION INSTRUMENT_OPTION num2str(SEGMENT_OPTION) '_AlignmentDiff_' num2str(YEAR_OPTION)];

% Check for existence of path for writing extracted features.
  root_path = deriveRootPath();
  full_data_path = [root_path DATA_PATH];
  
  if(~isequal(exist(full_data_path, 'dir'), 7))
    error('Error in your file path.');
  end

NUM_FEATURES = 4; % diff, len, pct
HOP_SIZE = 256;
WINDOW_SIZE = 1024;
Resample_fs = 44100;
% Scanning Options.
if YEAR_OPTION == '2013'
    year_folder = '2013-2014';
elseif YEAR_OPTION == '2014'
    year_folder = '2014-2015';
elseif YEAR_OPTION == '2015'
    year_folder = '2015-2016';
else
    disp('Error in year option');
end
    
FBA_RELATIVE_PATH = ['..' slashtype '..' slashtype '..' slashtype '..' slashtype 'FBA2013data' slashtype year_folder];
% BAND_OPTION = 'middle';
% INSTRUMENT_OPTION = 'Oboe';
% SEGMENT_OPTION = 2;
SCORE_OPTION = [];

% Read data from the database.
disp('Scanning database for files and metadata...');
audition_metadata = scanFBA(FBA_RELATIVE_PATH, ...
                            BAND_OPTION, INSTRUMENT_OPTION, ...
                            SEGMENT_OPTION, SCORE_OPTION, YEAR_OPTION);
disp('Done scanning database.');
                          
% Figure out size of data, for preallocating memory.
assessments = audition_metadata.assessments{1};
assessments = assessments(1, :);
assessments = assessments(assessments ~= -1);
num_labels = size(assessments, 2);
num_students = size(audition_metadata.file_paths, 1); 

% Preallocate memory.
features = zeros(num_students, NUM_FEATURES);
labels = zeros(num_students, num_labels);
%����
invalidCnt = 0;
invalidNo = [];

disp('Extracting features...');

% One student at a time.
for student_idx = 1:num_students 
  disp(['Processing student: ' num2str(student_idx)]);
  file_name = audition_metadata.file_paths{student_idx};
  segments = audition_metadata.segments{student_idx};
  student_assessments = audition_metadata.assessments{student_idx};
  
  %����
  %file_name
  
  % Retrieve audio for each segment.
  %����
  if (isempty(segments) == 1)
      invalidCnt = invalidCnt + 1;
      invalidNo = [invalidNo student_idx];
      continue;
  end
  [segmented_audio, Fs] = scanAudioIntoSegments(file_name, segments);
  current_audio = segmented_audio{1};

  % resample audio
  current_audio = resample(current_audio,Resample_fs,Fs);
  
  % Normalize audio;
  normalized_audio = mean(current_audio, 2);
  normalized_audio = normalized_audio ./ max(abs(normalized_audio));

  % Extract features.
  features(student_idx, :) = ...
       AlignmentDifference(normalized_audio, Resample_fs, WINDOW_SIZE, HOP_SIZE, YEAR_OPTION, NUM_FEATURES);

  % Store all assessments.
  segment_assessments = student_assessments(1, :);
  segment_assessments = segment_assessments(segment_assessments ~= -1);
  labels(student_idx, :) = segment_assessments;
  %����
  if(mod(student_idx, 10) == 0)
    save([full_data_path write_file_name 'sub'], 'features', 'labels');
    sound(randn(4096, 1), 8192);
  end
end

%warnwave
WarnWave = [sin(1:.6:400), sin(1:.7:400), sin(1:.4:400)];
Audio = audioplayer(WarnWave, 22050);
play(Audio);

% Write results to the file.disp('Done extracting features. Writing results to file.');
save([full_data_path write_file_name 'final'], 'features', 'labels');
disp('Done writing file.');

%����
invalidNo

%a = sum(features, 2);
%features = features(a>0, :);
%labels = labels(a>0, :);
features(invalidNo, :) = [];
labels(invalidNo, :) = [];
save([full_data_path write_file_name 'final'], 'features', 'labels');

end
