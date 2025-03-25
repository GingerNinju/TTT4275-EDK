clear; clc;

classes_to_plot = [1, 2, 3, 6];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Classical'});
feature_names = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo'};
colors = lines(4);

% Load the data
filename = 'features/task1_features.txt';
data = readtable(filename, 'Delimiter', '\t');
X = table2array(data(:, feature_names));
labels = table2array(data(:, 'GenreID'));

% Normalize the data
X = (X - mean(X)) ./ std(X);

% Boxplot
% figure;
% for f = 1:4
%     subplot(2, 2, f);
%     data = []; groups = [];

%     for c = classes_to_plot
%         i = labels == c;
%         data = [data; X(i, f)];
%         groups = [groups; c * ones(sum(i), 1)];
%     end

%     boxplot(data, groups, 'Labels', values(classes_to_name_map));
%     title(['Distribution of ', feature_names{f}]);
%     xlabel('Class'); ylabel('Feature Value');
% end

% Histograms
% for f = 1:4
%     figure; hold on;

%     for i = 1:4
%         c = classes_to_plot(i); % Current class
%         idx = labels == c; % Indices of the current class
%         histogram(X(idx, f), 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', colors(i, :));
%     end

%     title(['Histogram of ', feature_names{f}]);
%     xlabel('Feature Value'); ylabel('Frequency');
%     legend(values(classes_to_name_map));
%     hold off;
% end

% KDE Plot
figure;
for f = 1:4
    subplot(2, 2, f); hold on;
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