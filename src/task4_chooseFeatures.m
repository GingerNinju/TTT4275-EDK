clc; clear;

function combList = generatorAllComibinations(inputList, k)
    N = numel(inputList);
    if N < k
        error('Not enough elements in inputList to generate combinations of size %d', k);
    end

    idxCombinations = nchoosek(1:N, k);
    numComb = size(idxCombinations, 1);
    combList = cell(numComb, k);

    for i = 1:k
        combList(i, :) = inputList(idxCombinations(i, :));
    end
end

function [rayleigh_coeff] = compute_rayleigh(data, selected_features, classes)
    n_classes = length(classes);
    class_means = [];
    intra_variances = zeros(n_classes, 1);
    class_sizes = zeros(n_classes, 1);

    for k = 1:n_classes
        class_id = classes(k);
        class_data = data(data.GenreID == class_id, selected_features);
        X = table2array(class_data);

        class_sizes(k) = size(X, 1);
        class_means(k, :) = mean(X);
        intra_variances(k) = var(X(:));
    end

    overall_mean = mean(class_means);
    inter_variance = sum(class_sizes .* (class_means - overall_mean).^2) / sum(class_sizes);

    rayleigh_coeff = inter_variance / sum(intra_variances);
end

% --- Data Loading ---
filename = "features/task4_filtered_30s.txt";
data = readtable(filename, 'Delimiter', '\t');
classes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

% --- Feature Selection ---
% Trying all the possible 10-uplets among the features
% Keep the one with the best Rayleigh coefficient

all_features = data.Properties.VariableNames;
features_subsets = generatorAllComibinations(all_features, 10);
rayleigh_history = [];

for i = 1:size(features_subsets, 1)
    current_features = features_subsets(i, :);
    [rayleigh_coeff] = compute_rayleigh(data, current_features, classes);
    rayleigh_history = [rayleigh_history; {current_features, rayleigh_coeff}];
end

% Sort the Rayleigh coefficients
rayleigh_history = sortrows(rayleigh_history, 2, 'descend');
% Display the best 10-uplet
fprintf('Best 10-uplet of features:\n');
disp(rayleigh_history{1, :});