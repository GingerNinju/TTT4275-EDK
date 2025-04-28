clc; clear;

filename = "../data/GenreClassData_30s.txt";

% Read the data
data = readtable(filename, 'Delimiter', '\t');
classes_to_plot = [1, 2, 3, 6];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Classical'});

% Plot the feature distribution of 'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo' over the classes
features = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo'};

% Normalize features (z-score)
X = table2array(data(:, features));
X = zscore(X);
genreID = data.GenreID; % Preserve the GenreID column
data = array2table(X, 'VariableNames', features);
data.GenreID = genreID; % Reattach the GenreID column

for i = 1:length(features)
    feature = features{i};

    fprintf('Bhattacharyya distances for feature: %s\n', feature);
    
    % Extract data for each class
    class_distributions = cell(1, length(classes_to_plot));
    for j = 1:length(classes_to_plot)
        class = classes_to_plot(j);
        class_data = data(data.GenreID == class, :);
        [f, x] = ksdensity(class_data.(feature));
        class_distributions{j} = struct('f', f, 'x', x);
    end
    
    % Compute pairwise Bhattacharyya distances
    for j = 1:length(classes_to_plot)
        for k = j+1:length(classes_to_plot)
            % Interpolate to a common x-axis
            x_common = linspace(max(min(class_distributions{j}.x), min(class_distributions{k}.x)), ...
                                min(max(class_distributions{j}.x), max(class_distributions{k}.x)), 1000);
            f1_interp = interp1(class_distributions{j}.x, class_distributions{j}.f, x_common, 'linear', 0);
            f2_interp = interp1(class_distributions{k}.x, class_distributions{k}.f, x_common, 'linear', 0);
            
            % Compute Bhattacharyya coefficient
            bc = sum(sqrt(f1_interp .* f2_interp)) * (x_common(2) - x_common(1));
            
            % Convert to Bhattacharyya distance
            bd = -log(bc);
            fprintf('  Distance between %s and %s: %.4f\n', ...
                classes_to_name_map(classes_to_plot(j)), ...
                classes_to_name_map(classes_to_plot(k)), bd);
        end
    end
end

% Scatter plots for every pair of features
figure;
plot_idx = 1;
for i = 1:length(features)
    for j = i+1:length(features)
        subplot(2, 3, plot_idx);
        hold on;
        for k = 1:length(classes_to_plot)
            class = classes_to_plot(k);
            class_data = data(data.GenreID == class, :);
            scatter(class_data.(features{i}), class_data.(features{j}), 10, 'filled', 'DisplayName', classes_to_name_map(class));
            
            % Compute and plot the barycenter
            barycenter_x = mean(class_data.(features{i}));
            barycenter_y = mean(class_data.(features{j}));
            scatter(barycenter_x, barycenter_y, 50, 'x', 'LineWidth', 1.5, 'DisplayName', [classes_to_name_map(class), ' Barycenter']);
        end
        xlabel(features{i});
        ylabel(features{j});
    
        if plot_idx == 1
            legend('show');
        end
        title(['Scatter: ', features{i}, ' vs ', features{j}]);
        set(findobj(gca, 'Type', 'Scatter', '-and', 'Marker', 'x'), 'SizeData', 300); % Increase width of crosses
        hold off;
        plot_idx = plot_idx + 1;
    end
end