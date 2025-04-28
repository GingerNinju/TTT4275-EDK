clear; clc;

classes_to_plot = [3, 7];
classes_to_name_map = containers.Map(classes_to_plot, {'Disco', 'Rock'});
feature_names = {'spectral_flatness_mean', 'spectral_flatness_var', 'mfcc_4_mean', 'mfcc_8_std', 'mfcc_4_std', 'mfcc_11_mean', 'mfcc_12_std', ...
 'mfcc_5_mean', 'chroma_stft_7_std', 'mfcc_1_std', 'mfcc_10_mean', 'mfcc_9_mean', 'mfcc_8_mean', 'mfcc_3_mean', 'chroma_stft_11_mean', ...
 'spectral_contrast_mean', 'spectral_bandwidth_mean', 'rmse_var', 'rmse_mean'};

colors = [
    0.0, 0.0, 0.0       % black
    0.9, 0.6, 0.0       % orange
    0.35, 0.7, 0.9      % sky blue
    0.0, 0.6, 0.5       % teal
    0.95, 0.9, 0.25     % yellow
    0.8, 0.4, 0.0       % dark orange
    0.8, 0.6, 0.7       % light purple
    0.0, 0.45, 0.7      % blue
    0.6, 0.6, 0.6       % grey
    0.8, 0.0, 0.0       % red
];

% Load the data
filename = '../data/GenreClassData_10s.txt';
data = readtable(filename, 'Delimiter', '\t');
X = table2array(data(:, feature_names));
labels = table2array(data(:, 'GenreID'));

% Normalize the data
X = (X - mean(X)) ./ std(X);

% KDE Plot
% Group features into subplots
subplot_groups = {
    {'mfcc_4_mean', 'mfcc_8_std', 'mfcc_4_std', 'mfcc_11_mean', 'mfcc_12_std', 'mfcc_5_mean', 'mfcc_1_std', 'mfcc_10_mean', 'mfcc_9_mean', 'mfcc_8_mean', 'mfcc_3_mean'}, ...
    {'spectral_flatness_mean', 'spectral_flatness_var', 'spectral_contrast_mean', 'spectral_bandwidth_mean'}, ...
    {'chroma_stft_7_std', 'chroma_stft_11_mean'}, ...
    {'rmse_var', 'rmse_mean'}
};

for g = 1:length(subplot_groups)
    figure;
    group_features = subplot_groups{g};
    num_features = length(group_features);
    for f = 1:num_features
        feature_idx = find(strcmp(feature_names, group_features{f}));
        subplot(ceil(num_features / 2), 2, f);
        for i = 1:length(classes_to_plot)
            c = classes_to_plot(i); % Current class
            idx = labels == c-1; % Indices of the current class
            [density, x] = ksdensity(X(idx, feature_idx));
            % Adjust line width for better visualization
            plot(x, density, 'LineWidth', 2, 'Color', colors(i, :));
            hold on;
        end
        title(['KDE Plot of ', strrep(group_features{f}, '_', '\_')]);
        xlabel('Feature Value'); ylabel('Density');
        legend(values(classes_to_name_map));
        hold off;
    end
end