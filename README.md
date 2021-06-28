# Stochastic Simulation Algorithm

This is an implementation of the *Stochastic Simulation Algorithm* (SSA) as outlined in Gillespie's paper, [*"Exact Simulation of Coupled Chemical Reactions."*](https://pubs.acs.org/doi/abs/10.1021/j100540a008)

## Introduction to stochastic chemical reactions

Many systems of chemical reactions, that are of interest to scientists and engineers, assumes the the number of molecules involved is large. This allows them to assume that said number of molecules can be represented as a continous variable, a real number, which then allows the system of chemical reactions to be represented as a system of ordinary differential equations (ODEs). This large number assumption, however, is not always valid. In these situations, the deterministic system of ODEs is replaced with a stochastic version.

There are two main approaches too solving the stochastic system of chemical reactions: a microscopic approach where you consider each possible series of events (out of potentially infinitely many possibilities) individually and a macroscopic approch where you track how the distribution of the various outcomes evolves over time. The Stochastic Simulation Algorithm is a microscopic approach developed by Daniel Gillespie.


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
