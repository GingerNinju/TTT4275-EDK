clear; clc;

filename = 'data/GenreClassData_30s.txt';
selected_features = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo'};

% Read header line
fid = fopen(filename, 'r');
header_line = fgetl(fid);
fclose(fid);

% Parse header into column names (char vectors)
columns = strsplit(header_line, '\t');

% Columns to keep (original names from file header)
essential_columns = {'Track ID', 'GenreID', 'Genre', 'Type'};
columns_to_keep = [essential_columns, selected_features];

% Validate presence of columns
[is_present, idx_in_header] = ismember(columns_to_keep, columns);
if any(~is_present)
    missing = columns_to_keep(~is_present);
    error(['Missing columns: ', strjoin(missing, ', ')]);
end

% Detect import options -- Used to convert column names with spaces to MATLAB's variable names
opts = detectImportOptions(filename, 'Delimiter', '\t');

% Display variable names recognized by MATLAB (after header sanitization, ie removing spaces)
disp('Recognized variable names by MATLAB:');
disp(opts.VariableNames');

% Map original names to MATLAB variable names
original_to_variable = containers.Map(columns, opts.VariableNames);

% Convert selected column names to MATLAB's version -- Thank you ChatGPT
selected_vars = cellfun(@(c) original_to_variable(c), columns_to_keep, 'UniformOutput', false);

% Select only required variables
opts.SelectedVariableNames = selected_vars;
data = readtable(filename, opts);

% Save the data to a new file
writetable(data, 'features/task1_features.txt', 'Delimiter', '\t');