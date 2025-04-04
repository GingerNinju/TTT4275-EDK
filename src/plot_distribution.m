clc; clear;

filename = "../data/GenreClassData_30s.txt";
classes_to_plot = [1, 2, 3, 6];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Classical'});
features = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'mfcc_1_std'}; % spectral_contrast_mean

mode = "2D";

% Read the data
data = readtable(filename, 'Delimiter', '\t');

if mode == "2D"
    % Get every pair (plane) of features
    pairs = nchoosek(features, 2);

    % For each pair, scatter points with color for their class (4 classes total)
    for i = 1:size(pairs, 1)
        feature1 = pairs(i, 1);
        feature2 = pairs(i, 2);
        figure;
        hold on;
        for j = 1:length(classes_to_plot)
            class = classes_to_plot(j);
            class_data = data(data.GenreID == class, :);
            % Scatter plot
            scatter(class_data.(feature1{1}), class_data.(feature2{1}), 'filled', 'DisplayName', classes_to_name_map(class));
            % Plot barycenter of the classes
            barycenter = mean(class_data{:, {feature1{1}, feature2{1}}});
            scatter(barycenter(1), barycenter(2), 100, 'x', 'LineWidth', 2, 'DisplayName', ['Barycenter of ', classes_to_name_map(class)]);
        end
        title(['Scatter plot of ', feature1, ' vs ', feature2]);
        xlabel(feature1);
        ylabel(feature2);
        legend('show');
        hold off;
    end
end
if mode == "3D"
    % Get every triplet (3D) of features
    triplets = nchoosek(features, 3);  % where features is a cell array of strings or chars

    % For each triplet, scatter points with color for their class (4 classes total)
    for i = 1:size(triplets, 1)
        feature1 = triplets{i, 1};  % extract as string
        feature2 = triplets{i, 2};
        feature3 = triplets{i, 3};
        
        figure;
        hold on;
        for j = 1:length(classes_to_plot)
            class = classes_to_plot(j);
            class_data = data(data.GenreID == class, :);
            
            scatter3(class_data.(feature1), class_data.(feature2), class_data.(feature3), ...
                'filled', 'DisplayName', classes_to_name_map(class));
            
            barycenter = mean(class_data{:, {feature1, feature2, feature3}});
            scatter3(barycenter(1), barycenter(2), barycenter(3), ...
                100, 'x', 'LineWidth', 2, 'DisplayName', ['Barycenter of ', classes_to_name_map(class)]);
        end
        title(['Scatter plot of ', feature1, ' vs ', feature2, ' vs ', feature3]);
        xlabel(feature1);
        ylabel(feature2);
        zlabel(feature3);
        legend('show');
        hold off;
    end
end
