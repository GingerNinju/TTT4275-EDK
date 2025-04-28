clear;

classes_to_plot = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Blues', 'Reggae', 'Classical', 'Rock', 'Hip-Hop', 'Country', 'Jazz'});

% Load the features
filename = '../data/GenreClassData_10s.txt';
data = readtable(filename, 'Delimiter', '\t');
features = {'spectral_flatness_mean', 'spectral_flatness_var', 'mfcc_4_mean', 'mfcc_8_std', 'mfcc_4_std', 'mfcc_11_mean', 'mfcc_12_std', ...
 'mfcc_5_mean', 'chroma_stft_7_std', 'mfcc_1_std', 'mfcc_10_mean', 'mfcc_9_mean', 'mfcc_8_mean', 'mfcc_3_mean', 'chroma_stft_11_mean', ...
 'spectral_contrast_mean', 'spectral_bandwidth_mean', 'rmse_var', 'rmse_mean'};

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

% Run the k-NN algorithm for k values from 1 to 10
k_values = 1:15;
accuracies = zeros(size(k_values));

for k = k_values
    y_pred = zeros(N, 1);
    for i = 1:N
        distances = sum(abs(X_train - X_test(i, :)), 2); % Manhattan distance
        [~, indices] = mink(distances, k);
        nearest_labels = y_train(indices);
        y_pred(i) = mode(nearest_labels);
    end
    accuracies(k) = sum(y_pred == y_test) / length(y_test);
end

% Plot the accuracy over k
figure;
plot(k_values, accuracies, '-o');
xlabel('Number of Neighbors (k)');
ylabel('Accuracy');
title('Accuracy vs. Number of Neighbors (k)');
grid on;