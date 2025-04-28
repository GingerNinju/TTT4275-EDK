# TTT4275-EDK: Genre Classification Project

This project implements various tasks for genre classification using audio features extracted from music tracks. The tasks include feature extraction, data visualization, k-Nearest Neighbors (k-NN) classification, and feature importance analysis.

## Project Structure

- **`src/`**: Contains MATLAB scripts for different tasks.
  - **`task1.m`**: Implements k-NN classification for a subset of features.
  - **`task2.m`**: Visualizes feature distributions and computes Bhattacharyya distances.
  - **`task2_scatter.m`**: Generates scatter plots for feature pairs with class barycenters.
  - **`task3.m`**: Combines KDE plots and k-NN classification for selected features.
  - **`task4.m`**: Performs k-NN classification with precision, recall, and confusion matrix analysis.
  - **`task4_plots.m`**: Visualizes KDE plots for selected features and classes.
  - **`task4_k.m`**: Analyzes the effect of varying `k` in k-NN classification.
  - **`task4_importance.m`**: Identifies the most discriminative features using Bhattacharyya distances.
  - **`distributions.m`**: Visualizes KDE plots for all features across all classes.

- **`data/`**: Contains input datasets used for analysis and classification.
  - `GenreClassData_10s.txt`: Dataset with 10-second audio segments.
  - `GenreClassData_30s.txt`: Dataset with 30-second audio segments.

- **`output/`**: Stores output files such as predictions and processed data.

## Requirements

- MATLAB R2020b or later.
- Datasets in the `data/` directory.

## Outputs

- Classification predictions are saved in the `output/` directory.
- Visualizations are displayed as figures and can be saved manually.

## Authors

This project was developed as part of the TTT4275 course at NTNU.

## License

This project is for educational purposes and is not licensed for commercial use.
