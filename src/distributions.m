clear; clc;

classes_to_plot = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
classes_to_name_map = containers.Map(classes_to_plot, {'Pop', 'Metal', 'Disco', 'Blues', 'Reggae', 'Classical', 'Rock', 'Hip-Hop', 'Country', 'Jazz'});
feature_names = {'spectral_rolloff_mean', 'mfcc_1_mean', 'spectral_centroid_mean', 'tempo', 'zero_cross_rate_mean', 'zero_cross_rate_std', ...
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
for f = 1:length(feature_names)
    figure;
    for i = 1:length(classes_to_plot)
        c = classes_to_plot(i); % Current class
        idx = labels == c-1; % Indices of the current class
        [density, x] = ksdensity(X(idx, f));
        % Adjust line width for better visualization
        plot(x, density, 'LineWidth', 2, 'Color', colors(i, :));
        hold on;
    end

    title(['KDE Plot of ', strrep(feature_names{f}, '_', '\_')]);
    xlabel('Feature Value'); ylabel('Density');
    legend(values(classes_to_name_map));
    hold off;
end