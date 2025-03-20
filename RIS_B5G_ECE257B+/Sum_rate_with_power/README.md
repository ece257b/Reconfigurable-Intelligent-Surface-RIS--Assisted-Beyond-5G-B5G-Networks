# Sum Rate and Power Analysis for RIS-aided Systems

This project analyzes the relationship between sum rate and power in RIS-aided systems, implementing both SDR and AO methods for optimization. The code provides comprehensive comparisons between different scenarios including with/without RIS and random phase shifts.

## Files Description

### Main.m
- Analyzes power requirements for different sum rates
- Compares multiple scenarios:
  - SDR optimization
  - Lower bound
  - Random phase shifts
  - Without IRS
  - AO optimization

### Main2.m
- Analyzes achievable sum rates for different transmit powers
- **Note**: Full simulation takes approximately 30 minutes due to iterations
- Time-saving option: Reduce `frame` value (default=3) to decrease computation time
- Pre-generated results available in `sumrate_power.mat`

## System Parameters

- Number of AP antennas (M): 10
- Number of RIS elements (N): 40-70
- Path loss model parameters defined in PathLossModel.m
- Multiple frames for averaging results

## How to Run
2. Run plotting section of Main2.m
### Full Simulation
1. Run Main.m for power vs sum rate analysis
2. Run Main2.m for sum rate vs power analysis (≈30 min)
## Output Results
load('sumrate_power.mat')
load other png files as results
### Main.m
- Transmit power requirements for different sum rates
- Comparison between optimization methods
- Performance gain with RIS
### Main2.m
- Achievable sum rates for different transmit powers
- Comparison of different schemes
- RIS performance benefits
## Dependencies
- MATLAB Optimization Toolbox
- CVX for solving optimization problems
- Custom functions:
  - PathLossModel.m
  - SDR_solving.m
  - AO.m
## Performance Comparison
The code compares:

- SDR-based optimization
- Alternating optimization
- Random phase shifts
- System without IRS
- Theoretical lower bounds
## Notes
1. Adjust frame parameter in Main2.m to balance between accuracy and computation time
2. Use pre-generated results for quick analysis
3. Path loss parameters can be modified in PathLossModel.m
4. Results are averaged over multiple frames for reliability


### Quick Results
1. Load pre-generated results:
```matlab
load('sumrate_power.mat')
load other png files as results