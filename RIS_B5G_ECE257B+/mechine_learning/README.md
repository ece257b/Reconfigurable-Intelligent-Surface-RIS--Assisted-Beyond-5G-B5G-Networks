# RIS Machine Learning Analysis

This project implements various machine learning models to analyze and predict spectrum efficiency based on RIS array and user numbers. By leveraging machine learning techniques, we can generate more data points intelligently and obtain predictions efficiently, which significantly reduces the time consumption compared to traditional AO iteration methods.

## Requirements

### Software
- MATLAB R2020b or later
- Statistics and Machine Learning Toolbox
- Deep Learning Toolbox

### Required Toolboxes
1. Statistics and Machine Learning Toolbox (for SVM and polynomial regression)
2. Deep Learning Toolbox (for neural networks)

## How to Run

1. Open MATLAB
2. Navigate to the project directory
3. Run `ml.m` script

## Runtime Information
- Typical runtime: 30-60 seconds
- Memory requirement: ~2GB RAM

## Results Generated

The script generates four figures:
1. Original data visualization (Figure 1)
2. Comparison of all ML models (Figure 2)
3. Error analysis of best model (Figure 3)
4. Best model prediction with original data points (Figure 4)

## Performance Metrics
The code outputs:
- MSE (Mean Squared Error)
- R² (R-squared) values for each model
- Detailed analysis summary

## Dataset

The spectrum efficiency dataset is included in the code (`P5` matrix). It contains:
- RIS array numbers: 30:5:50
- User numbers: 40:5:60
- 25 data points in total (5×5 matrix)

## Troubleshooting

Common issues:
1. "Undefined function 'fitrsvm'" - Install Statistics and Machine Learning Toolbox
2. "Out of memory" - Reduce dense grid resolution in prediction section
3. "Invalid data dimensions" - Check if P5 matrix is properly defined

