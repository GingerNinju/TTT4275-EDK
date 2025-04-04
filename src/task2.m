clc; clear;

filename = "../data/GenreClassData_30s.txt";

% Read the data
data = readtable(filename, 'Delimiter', '\t');
classes_to_plot = [1, 2, 3, 6];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Classical'});

% Plot the feature distribution of 'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo' over the classes
features = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo'};
for i = 1:length(features)
    feature = features{i};
    figure;
    hold on;
    for j = 1:length(classes_to_plot)
        class = classes_to_plot(j);
        class_data = data(data.GenreID == class, :);
        % Continuous plot
        [f, x] = ksdensity(class_data.(feature));
        plot(x, f, 'LineWidth', 2);
    end
    title(['Distribution of ', feature]);
    xlabel(feature);
    ylabel('Probability');
    legend(arrayfun(@(x) classes_to_name_map(x), classes_to_plot, 'UniformOutput', false));
    hold off;
end
