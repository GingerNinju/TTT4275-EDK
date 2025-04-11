clc; clear;

% === Loading data ===
filename = "../data/GenreClassData_30s.txt";
data = readtable(filename, 'Delimiter', '\t');
classes_to_keep = [1, 2, 3, 4, 6];

% === Preparation ===
all_features = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo', 'zero_cross_rate_mean', 'zero_cross_rate_std', ...
    'rmse_mean', 'rmse_var', 'spectral_centroid_var', ...
    'spectral_bandwidth_mean', 'spectral_bandwidth_var', ...
    'spectral_rolloff_var', 'spectral_contrast_mean', 'spectral_contrast_var', ...
    'spectral_flatness_mean', 'spectral_flatness_var', 'chroma_stft_1_mean', ...
    'chroma_stft_2_mean', 'chroma_stft_3_mean', 'chroma_stft_4_mean', ...
    'chroma_stft_5_mean', 'chroma_stft_6_mean', 'chroma_stft_7_mean', ...
    'chroma_stft_8_mean', 'chroma_stft_9_mean', 'chroma_stft_10_mean', ...
    'chroma_stft_11_mean', 'chroma_stft_12_mean', 'chroma_stft_1_std', ...
    'chroma_stft_2_std', 'chroma_stft_3_std', 'chroma_stft_4_std', ...
    'chroma_stft_5_std', 'chroma_stft_6_std', 'chroma_stft_7_std', ...
    'chroma_stft_8_std', 'chroma_stft_9_std', 'chroma_stft_10_std', ...
    'chroma_stft_11_std', 'chroma_stft_12_std', ...
    'mfcc_2_mean', 'mfcc_3_mean', 'mfcc_4_mean', 'mfcc_5_mean', ...
    'mfcc_6_mean', 'mfcc_7_mean', 'mfcc_8_mean', 'mfcc_9_mean', ...
    'mfcc_10_mean', 'mfcc_11_mean', 'mfcc_12_mean', 'mfcc_1_std', ...
    'mfcc_2_std', 'mfcc_3_std', 'mfcc_4_std', 'mfcc_5_std', ...
    'mfcc_6_std', 'mfcc_7_std', 'mfcc_8_std', 'mfcc_9_std', ...
    'mfcc_10_std', 'mfcc_11_std', 'mfcc_12_std'};

remaining_features = all_features;
selected_features = {};

% === Mandatory prioritized features ===
prioritary_features = {'zero_cross_rate_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo'};
prioritary_to_use = intersect(prioritary_features, all_features);
n_prioritary_needed = 4;

n_classes = length(classes_to_keep);
max_features = 6;

rayleigh_history = [];

% Step 1: Force the selection of 3 out of the 4 prioritized features
forced_features = {};
for i = 1:n_prioritary_needed
    best_score = -inf;
    best_feature = '';

    for j = 1:length(prioritary_to_use)
        candidate_feature = prioritary_to_use{j};
        if ismember(candidate_feature, forced_features)
            continue;
        end

        current_features = [selected_features, candidate_feature];
        [rayleigh_coeff] = compute_rayleigh(data, current_features, classes_to_keep);

        if rayleigh_coeff > best_score
            best_score = rayleigh_coeff;
            best_feature = candidate_feature;
        end
    end

    selected_features = [selected_features, best_feature];
    forced_features = [forced_features, best_feature];
    remaining_features = setdiff(remaining_features, best_feature);
    rayleigh_history = [rayleigh_history; best_score];

    fprintf('Prioritized feature %d: %s — Rayleigh = %.4f\n', ...
        i, best_feature, best_score);
end

% Step 2: Freely select remaining features until reaching max_features
while length(selected_features) < max_features
    best_score = -inf;
    best_feature = '';

    for i = 1:length(remaining_features)
        candidate_feature = remaining_features{i};
        current_features = [selected_features, candidate_feature];
        [rayleigh_coeff] = compute_rayleigh(data, current_features, classes_to_keep);

        if rayleigh_coeff > best_score
            best_score = rayleigh_coeff;
            best_feature = candidate_feature;
        end
    end

    selected_features = [selected_features, best_feature];
    remaining_features = setdiff(remaining_features, best_feature);
    rayleigh_history = [rayleigh_history; best_score];

    fprintf('Added feature: %s — Rayleigh = %.4f\n', ...
        best_feature, best_score);
end

% === Final result ===
fprintf('\nSelected features:\n');
disp(selected_features');
fprintf('Rayleigh coefficient history:\n');
disp(rayleigh_history);

%% === Function to compute the Rayleigh coefficient ===
function R = compute_rayleigh(data, selected_features, classes_to_keep)
    n_classes = length(classes_to_keep);
    class_means = [];
    intra_variances = zeros(n_classes, 1);
    class_sizes = zeros(n_classes, 1);

    for k = 1:n_classes
        class_id = classes_to_keep(k);
        class_data = data(data.GenreID == class_id, selected_features);
        X = table2array(class_data);

        class_sizes(k) = size(X, 1);
        class_means(k, :) = mean(X, 1);
        intra_variances(k) = trace(cov(X));
    end

    global_mean = mean(class_means, 1);

    inter_class_var = 0;
    for k = 1:n_classes
        diff = class_means(k, :) - global_mean;
        inter_class_var = inter_class_var + class_sizes(k) * (norm(diff)^2);
    end
    inter_class_var = inter_class_var / sum(class_sizes);

    intra_class_var = sum(class_sizes .* intra_variances) / sum(class_sizes);
    R = inter_class_var / intra_class_var;
end