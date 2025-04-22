clear;

classes_to_plot = [1, 2, 3, 6];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Classical'});

% Load the features
filename = '../data/GenreClassData_30s.txt';
data = readtable(filename, 'Delimiter', '\t');
features = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_flatness_mean', 'tempo'};

% Define matrices
X = table2array(data(:, features));
labels = table2array(data(:, 'GenreID')); % GenreID is the class label

% Normalize features (z-score)
X = zscore(X); % What this does is it subtracts the mean of each feature and divides by the standard deviation

% Normalize features (min-max)
% X = (X - min(X)) ./ (max(X) - min(X)); % This is the min-max normalization

% Compute correlation matrices
corr_matrix = corr(X);
figure;
imagesc(corr_matrix);
colorbar;
title('Correlation Matrix');
xlabel('Features'); ylabel('Features');
set(gca, 'XTick', 1:length(features), 'XTickLabel', features, 'YTick', 1:length(features), 'YTickLabel', features);
axis square;
% Set the colormap
colormap('jet');
% Set the color limits
clim([-1 1]);

maximums = zeros(length(features), length(classes_to_plot));

% KDE Plot
figure;
for f = 1:length(features)
    subplot(2, 3, f); hold on;
    for i = 1:4
        c = classes_to_plot(i); % Current class
        idx = labels == c; % Indices of the current class
        ksdensity(X(idx, f));

        maximums(f, i) = max(ksdensity(X(idx, f)));

    end

    title(['KDE Plot of ', strrep(features{f}, '_', '\_')]);
    xlabel('Feature Value'); ylabel('Density');
    legend(values(classes_to_name_map));
    hold off;
end

% Split the data into training and testing sets.
train_indices = strcmp(data.Type, 'Train'); test_indices = strcmp(data.Type, 'Test');

X_train = X(train_indices, :); X_test = X(test_indices, :);
y_train = labels(train_indices); y_test = labels(test_indices);
N = size(X_test, 1);

% k is the number of neighbors to consider
k = 5;

% Initialize the pred vector
y_pred = zeros(N, 1);

% Loop over each test sample
for i = 1:N
    % Computing the distance between the test sample and all training samples
    distances = sqrt(sum((X_train - X_test(i, :)).^2, 2));

    % Finding the k nearest neighbors
    [~, indices] = mink(distances, k);

    % Getting the labels of the k nearest
    nearest_labels = y_train(indices);

    % Finding the most common class
    y_pred(i) = mode(nearest_labels);
end

% Save the predictions to a file
writematrix(y_pred, '../output/task1_predictions.txt');

% Compute the accuracy
accuracy = sum(y_pred == y_test) / length(y_test);

% Precision
precision = zeros(10, 1);
for i = 0:9
    TP = sum(y_pred == i & y_test == i);
    disp("Class " + i + ": TP = " + TP);
    FP = sum(y_pred == i & y_test ~= i);
    disp("Class " + i + ": FP = " + FP);
    if (TP + FP) == 0
        precision(i+1) = 0;
    else
        precision(i+1) = TP / (TP + FP);
    end
end
avg_precision = mean(precision);

% Recall
recall = zeros(10, 1);
for i = 0:9
    TP = sum(y_pred == i & y_test == i);
    FN = sum(y_pred ~= i & y_test == i);
    if (TP + FN) == 0
        recall(i+1) = 0;
    else
        recall(i+1) = TP / (TP + FN);
    end
end
avg_recall = mean(recall);

% Display
disp('Accuracy:');
disp(accuracy);
disp('Avg precision:');
disp(avg_precision);
disp('Avg recall:');
disp(avg_recall);

% Confusion matrix
C = confusionmat(y_test, y_pred);
disp('Confusion matrix:');
disp(C);

% Add genre name before each value
genre_names = {'Pop', 'Metal', 'Disco', 'Blues', 'Reggae', 'Classical', 'Rock', 'Hip-Hop', 'Country', 'Jazz'};
for i = 1:length(precision)
    disp("Class " + genre_names{i} + ": Precision = " + precision(i) + ", Recall = " + recall(i));
end

disp(maximums)