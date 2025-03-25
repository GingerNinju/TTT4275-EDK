clear; clc;

classes_to_plot = [1, 2, 3, 6];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Classical'});
feature_names = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_flatness_var', 'tempo', 'zero_cross_rate_mean'};
colors = lines(4);

% Load the data
filename = '../data/GenreClassData_30s.txt';
data = readtable(filename, 'Delimiter', '\t');
X = table2array(data(:, feature_names));
labels = table2array(data(:, 'GenreID'));

% Normalize the data
X = (X - mean(X)) ./ std(X);

% KDE Plot
figure;
for f = 1:length(feature_names)
    subplot(2, 3, f); hold on;
    for i = 1:4
        c = classes_to_plot(i); % Current class
        idx = labels == c; % Indices of the current class
        ksdensity(X(idx, f));
    end

    title(['KDE Plot of ', strrep(feature_names{f}, '_', '\_')]);
    xlabel('Feature Value'); ylabel('Density');
    legend(values(classes_to_name_map));
    hold off;
end