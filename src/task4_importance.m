clear; clc;

% Load and prepare data
filename = '../data/GenreClassData_10s.txt';
data = readtable(filename, 'Delimiter', '\t');
feature_names = {'spectral_flatness_mean', 'spectral_flatness_var', 'mfcc_4_mean', 'mfcc_8_std', ...
                'mfcc_4_std', 'mfcc_11_mean', 'mfcc_12_std', 'mfcc_5_mean', 'chroma_stft_7_std', ...
                'mfcc_1_std', 'mfcc_10_mean', 'mfcc_9_mean', 'mfcc_8_mean', 'mfcc_3_mean', ...
                'chroma_stft_11_mean', 'spectral_contrast_mean', 'spectral_bandwidth_mean', ...
                'rmse_var', 'rmse_mean'};
X = table2array(data(:, feature_names));
labels = table2array(data(:, 'GenreID'));
X = (X - mean(X)) ./ std(X); % Normalize

% Initialize variables
num_features = length(feature_names);
num_classes = 10;
feature_scores = zeros(num_features, 1);

% Calculate pairwise Bhattacharyya distances for all class combinations
for f = 1:num_features
    total_distance = 0;
    pair_count = 0;
    
    for c1 = 0:num_classes-2
        for c2 = c1+1:num_classes-1
            % Get data for current class pair
            x1 = X(labels == c1, f);
            x2 = X(labels == c2, f);
            
            % Estimate distributions
            [~, xi1] = ksdensity(x1);
            [~, xi2] = ksdensity(x2);
            
            % Ensure both PDFs use the same grid points
            min_x = min(min(xi1), min(xi2));
            max_x = max(max(xi1), max(xi2));
            xi = linspace(min_x, max_x, 100);
            pdf1 = ksdensity(x1, xi);
            pdf2 = ksdensity(x2, xi);
            
            % Calculate Bhattacharyya coefficient
            bc = sum(sqrt(pdf1 .* pdf2)) * (xi(2)-xi(1));
            
            % Convert to distance (higher = more separable)
            bd = -log(bc);
            
            total_distance = total_distance + bd;
            pair_count = pair_count + 1;
        end
    end
    
    % Average distance across all class pairs
    feature_scores(f) = total_distance / pair_count;
end

% Sort features by discriminative power
[sorted_scores, idx] = sort(feature_scores, 'descend');
top_features = feature_names(idx(1:5));
top_scores = sorted_scores(1:5);

% Display results
fprintf('Top 5 Most Discriminative Features:\n');
for i = 1:5
    fprintf('%d. %s (Score: %.4f)\n', i, top_features{i}, top_scores(i));
end

% Plot results
figure;
barh(top_scores);
set(gca, 'YTick', 1:5, 'YTickLabel', top_features);
xlabel('Average Bhattacharyya Distance (Higher = More Discriminative)');
title('Top 5 Most Discriminative Features');
grid on;