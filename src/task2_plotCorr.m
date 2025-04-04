clear; clc;

filename = "../data/GenreClassData_30s.txt";

% Read the data
data = readtable(filename, 'Delimiter', '\t');

% Extract the features
fixedFeatures = {'spectral_rolloff_mean', 'mfcc_1_mean', 'tempo'};
plotFeatures = {'chroma_stft_10_mean', 'chroma_stft_10_std', 'chroma_stft_11_mean', 'chroma_stft_11_std', 'chroma_stft_12_mean', 'chroma_stft_12_std', 'chroma_stft_1_mean', 'chroma_stft_1_std', 'chroma_stft_2_mean', 'chroma_stft_2_std', 'chroma_stft_3_mean', 'chroma_stft_3_std', 'chroma_stft_4_mean', 'chroma_stft_4_std', 'chroma_stft_5_mean', 'chroma_stft_5_std', 'chroma_stft_6_mean', 'chroma_stft_6_std', 'chroma_stft_7_mean', 'chroma_stft_7_std', 'chroma_stft_8_mean', 'chroma_stft_8_std', 'chroma_stft_9_mean', 'chroma_stft_9_std', 'mfcc_10_mean', 'mfcc_10_std', 'mfcc_11_mean', 'mfcc_11_std', 'mfcc_12_mean', 'mfcc_12_std', 'mfcc_1_std', 'mfcc_2_mean', 'mfcc_2_std', 'mfcc_3_mean', 'mfcc_3_std', 'mfcc_4_mean', 'mfcc_4_std', 'mfcc_5_mean', 'mfcc_5_std', 'mfcc_6_mean', 'mfcc_6_std', 'mfcc_7_mean', 'mfcc_7_std', 'mfcc_8_mean', 'mfcc_8_std', 'mfcc_9_mean', 'mfcc_9_std', 'rmse_mean', 'rmse_var', 'spectral_bandwidth_mean', 'spectral_bandwidth_var', 'spectral_centroid_var', 'spectral_contrast_mean', 'spectral_contrast_var', 'spectral_flatness_mean', 'spectral_flatness_var', 'spectral_rolloff_var', 'zero_cross_rate_mean', 'zero_cross_rate_std'};

disp_features = {'spectral_rolloff_mean', 'mfcc_1_mean', 'tempo', ''};

for i = 1:length(plotFeatures)
    disp_features{end} = plotFeatures{i};

    X = table2array(data(:, disp_features));
    X = zscore(X); % Normalize features (z-score)

    % Compute correlation matrix
    corr_matrix = corr(X);
    figure;
    imagesc(corr_matrix);
    colorbar;
    title(['Correlation Matrix of ', strrep(disp_features{end}, '_', '\_')]);
    xlabel('Features'); ylabel('Features');
    set(gca, 'XTick', 1:length(disp_features), 'XTickLabel', disp_features, 'YTick', 1:length(disp_features), 'YTickLabel', disp_features);
    axis square;
    % Set the colormap
    colormap('jet');
    % Set the color limits
    clim([-1 1]);
end