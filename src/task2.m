clear; clc;

classes_to_plot = [1, 2, 3, 6];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Classical'});
feature_names = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo'};

% Load the data
filename = 'features/task1_features.txt';
data = readtable(filename, 'Delimiter', '\t');
X = table2array(data(:, feature_names));
labels = table2array(data(:, 'GenreID'));

% Normalize the data
X = (X - mean(X)) ./ std(X);

figure;
for f = 1:4
    subplot(2, 2, f);
    data = []; groups = [];

    for c = classes_to_plot
        i = labels == c;
        data = [data; X(i, f)];
        groups = [groups; c * ones(sum(i), 1)];
    end

    boxplot(data, groups, 'Labels', values(classes_to_name_map));
    title(['Distribution of ', feature_names{f}]);
    xlabel('Class'); ylabel('Feature Value');
end