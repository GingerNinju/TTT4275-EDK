clear; clc;

filename = '../data/GenreClassData_30s.txt';

classes_to_plot = [1, 2, 3, 6];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Classical'});

% Read header line
fid = fopen(filename, 'r');
header_line = fgetl(fid);
fclose(fid);

data = readtable(filename, 'Delimiter', '\t');

columns = strsplit(header_line, '\t');
features_nb = length(columns) - 5; % Exclude the last column (GenreID)

% Loop through the columns 3 to 3 + features_nb
for i = 3:3 + features_nb - 1
    X = table2array(data(:, i));
    labels = table2array(data(:, 'GenreID'));

    % Normalize the data
    X = (X - mean(X)) ./ std(X);

    figure;
    hold on;
    for j = 1:length(classes_to_plot)
        c = classes_to_plot(j); % Current class
        idx = labels == c; % Indices of the current class
        ksdensity(X(idx));
    end
    title(['KDE Plot of ', strrep(columns{i}, '_', '\_')]);
    xlabel('Feature Value'); ylabel('Density');
    legend(values(classes_to_name_map));
    hold off;
end