# Power Convergence Analysis for RIS-aided Systems

This project implements power optimization algorithms for a RIS-aided multi-user MIMO system. Both SDR and AO methods demonstrate rapid convergence in power optimization, proving to be effective optimization approaches for this model with a typical runtime of 3 minutes. It compares the convergence performance between Semidefinite Relaxation (SDR) and Alternating Optimization (AO) methods for transmit power minimization.

## System Model

- MIMO system
- Multi-user scenario (default 4 users)
- Path loss and channel fading considered
- RIS array: 5×6 elements

## Key Features

1. Path loss model implementation
2. SDR method for RIS phase shift optimization
3. AO method for power minimization
4. Convergence comparison between algorithms

## How to Run

1. Run `Main2.m`
2. The program will automatically:
   - Initialize system parameters
   - Execute SDR method iterations
   - Execute AO method iterations
   - Plot convergence comparison
   - Output performance metrics

## Output Results

- Convergence comparison plot
  - SDR method convergence curve
  - AO method convergence curve
- Performance metrics
  - Number of iterations
  - Final transmit power (dBm)
  - Algorithm runtime

## Parameter Settings

- `Uk`: Number of users
- `epsilon`: Convergence threshold
- `M`: Number of transmit antennas
- `Nx`, `Ny`: RIS array dimensions
- `maxIter`: Maximum iterations

## Dependencies

- `PathLossModel2.m`: Path loss model
- `PMQoSSOCP.m`: Transmit beamforming optimization
- `IRS_MultiUser.m`: RIS phase shift optimization
- `AO_MultiUser.m`: Alternating optimization algorithm
- `SDR_MultiUser.m`: Semidefinite relaxation algorithm

## Important Notes

1. Ensure all dependent functions are in the same directory
2. Adjust `epsilon` to control convergence precision
3. Modify `maxIter` to control maximum iterations
4. Path loss parameters can be modified in `PathLossModel2.m`

## Algorithm Description

- SDR Method: Solves the RIS phase shift optimization problem using semidefinite relaxation
- AO Method: Alternately optimizes transmit beamforming and RIS phase shifts
- Both methods aim to minimize transmit power while satisfying QoS constraints

## Performance Comparison

The code provides direct comparison between SDR and AO methods in terms of:
- Convergence speed
- Final achieved transmit power
- Computational complexity