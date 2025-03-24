clear; clc;

% Load the features
filename = 'features/task1_features.txt';
data = readtable(filename, 'Delimiter', '\t');
features = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo'};

% Define matrices
X = table2array(data(:, features));
labels = table2array(data(:, 'GenreID')); % GenreID is the class label

% Normalize features (z-score)
X = zscore(X); % What this does is it subtracts the mean of each feature and divides by the standard deviation

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

% Compute the accuracy
accuracy = sum(y_pred == y_test) / length(y_test);
disp(['Accuracy: ', num2str(accuracy)]);