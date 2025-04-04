clear; clc;

filename = '../data/GenreClassData_30s.txt';
features_to_remove = {'Track ID', 'GenreID', 'Genre', 'Type', 'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo'};

% Read header line
fid = fopen(filename, 'r');
header_line = fgetl(fid);
fclose(fid);

% Parse header into column names (char vectors)
columns = strsplit(header_line, '\t');

% Validate presence of columns to remove
[is_present, idx_in_header] = ismember(features_to_remove, columns);
if any(~is_present)
    missing = features_to_remove(~is_present);
    error(['Missing columns: ', strjoin(missing, ', ')]);
end

% Detect import options -- Used to convert column names with spaces to MATLAB's variable names
opts = detectImportOptions(filename, 'Delimiter', '\t');

% Map original names to MATLAB variable names
original_to_variable = containers.Map(columns, opts.VariableNames);

% Convert features to remove to MATLAB's version
vars_to_remove = cellfun(@(c) original_to_variable(c), features_to_remove, 'UniformOutput', false);

% Select only variables not in the removal list
opts.SelectedVariableNames = setdiff(opts.VariableNames, vars_to_remove);
data = readtable(filename, opts);

% Save the data to a new file
writetable(data, 'features/task2_filtered_features.txt', 'Delimiter', '\t');
