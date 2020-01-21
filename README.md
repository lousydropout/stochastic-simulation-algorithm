# stochastic-simulation-algorithm

This is an implementation of the *Stochastic Simulation Algorithm* (SSA) as outlined in Gillespie's paper, [*"Exact Simulation of Coupled Chemical Reactions."*](https://pubs.acs.org/doi/abs/10.1021/j100540a008)

## Requirements
To run this repo, it is assumed that you have the following tools installed on a Linux of Mac OSX:
- g++
- Make
- [Processing](https://processing.org/) (Note: There is a .pde file for visualizing the results included in the pde/ directory. However, with the many upgrades processing made, this may no longer run.)

## How to run the program
In your terminal, type
```bash
make
```
in the parent directory. This will run the `Makefile` and proceed to create an executable named `stoch`. Then, to run `stoch`,
type
```bash
./stoch
```

The program `stoch` will output `.csv` files. These `.csv` files can then be either plotted using whatever plotting program you prefer or via the `plot_csv.pde` file, which animates the output using [`processing`](https://processing.org/).
