clear;

classes_to_plot = [1, 2, 3, 6];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Classical'});

% Load the features
filename = '../data/GenreClassData_30s.txt';
data = readtable(filename, 'Delimiter', '\t');
features = {'spectral_centroid_mean', 'mfcc_1_mean', 'spectral_rolloff_mean', 'spectral_flatness_mean'};

% Define matrices
X = table2array(data(:, features));
labels = table2array(data(:, 'GenreID')); % GenreID is the class label

% Normalize features (z-score)
X = zscore(X); % What this does is it subtracts the mean of each feature and divides by the standard deviation

maximums = zeros(length(features), length(classes_to_plot));

% KDE Plot
for f = 1:length(features)
    figure;
    hold on;
    for i = 1:length(classes_to_plot)
        c = classes_to_plot(i); % Current class
        idx = labels == c-1; % Indices of the current class
        [density, x] = ksdensity(X(idx, f));
        plot(x, density, 'LineWidth', 2); % Increase line width to 2

        maximums(f, i) = max(density);
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
    % distances = sqrt(sum((X_train - X_test(i, :)).^2, 2)); % Euclidean distance
    distances = sum(abs(X_train - X_test(i, :)), 2); % Manhattan distance

    % Finding the k nearest neighbors
    [~, indices] = mink(distances, k);

    % Getting the labels of the k nearest
    nearest_labels = y_train(indices);

    % Finding the most common class
    y_pred(i) = mode(nearest_labels);
end

% Save the predictions to a file
writematrix(y_pred, '../output/task3_predictions.txt');

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

figure;
confusionchart(C, genre_names, 'Title', 'Confusion Matrix', ...
    'RowSummary','row-normalized', 'ColumnSummary','column-normalized');
colormap('parula');
grid on;