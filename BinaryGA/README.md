# Binary Genetic Algorithm for Generalized Assignment Problem (GAP)

This project provides a binary-coded Genetic Algorithm (GA) implementation to solve the **Generalized Assignment Problem (GAP)**. The performance of the Binary GA is compared against two benchmark methods: **Optimal Solution** and **Greedy Approximation**.

---

## 📂 Project Structure

- `gap_gaTest-2.m`: Main script for solving GAP using a binary GA across 12 data files.
- `compareBGAvsOPvsAPP.m`: Compares GA performance to Optimal and Approximation (Greedy) using bar charts and summary tables.
- `gap_ga_results.csv`: Output file containing GA solution profits per instance.
- `BgaVSappVSopti.png`: Visualization of performance comparison between Binary GA, Approximation, and Optimal methods.
- `sphereBGA.m`: Demonstrates Binary GA on a continuous **Sphere Function** (benchmark function for optimization).
- `sphereBGAgraph.png`: Convergence plot of Binary GA solving the Sphere function.
- `gap12_binary_avg_results.csv`: Average of 10 Iteration of GAP 12

---

## 📌 Problem Description: GAP

The **Generalized Assignment Problem (GAP)** involves assigning users to servers in a way that maximizes profit under capacity constraints. Each user-server assignment has a profit and a resource requirement, and each server has a limited capacity.

### Objective:
Maximize total profit while ensuring:
- Each user is assigned to one server.
- Server capacities are not exceeded.

---

## 🧬 Binary Genetic Algorithm (GA)

Implemented with:
- Binary chromosome encoding
- Feasible solution initialization
- Fitness evaluation with capacity and assignment penalties
- Tournament selection
- Single-point crossover
- Bit-wise mutation
- Elitism & immigrants to avoid premature convergence

### Run:
```matlab
process_large_gap_ga();
```

### Output:
- `gap_ga_results.csv`: Profits from each instance
- `gap12_binary_avg_results.csv`: Averaged results for 10 runs on GAP file 12

---

## 📊 Comparison with Benchmarks

The `compareBGAvsOPvsAPP.m` script visualizes the performance comparison among:

- 🟩 **Greedy Approximation**
- 🟧 **Binary GA**(Only 12th GAP-10 Iterations)
- 🟦 **Optimal Solver**

### Run:
```matlab
compareAllAlgorithms();
```

### Output:
- `algorithm_comparison.png`: Bar chart visualization
- `algorithm_comparison.csv`: Tabular performance summary

---

## 🔬 Sphere Function (Test Function)

Demonstrates the binary GA on a simple optimization function:
\[ f(x) = \sum x_i^2 \]

### Run:
```matlab
sphereBGA.m
```

### Output:
- Prints best solution and fitness
- Shows convergence graph (`sphereBGAgraph.png`)

---

## 📈 Results Summary

- Binary GA provides **competitive solutions** close to optimal in many instances.
- Robust to problem size, with consistent performance across different datasets.
- Sphere function results show effective convergence behavior.

---

## 📎 How to Use

1. Place your GAP datasets in `/MATLAB Drive/gap dataset files/` (e.g., `gap1.txt`, `gap2.txt`, ..., `gap12.txt`).
2. Run `gap_gaTest-2.m` to evaluate all datasets.
3. Run `compareBGAvsOPvsAPP.m` to generate comparison charts.

---

## 🧠 Requirements

- MATLAB (R2020 or later recommended)
- No additional toolboxes needed

---

## 📮 Acknowledgements

This project showcases how a binary-coded GA can be applied to both combinatorial (GAP) and continuous (Sphere) optimization problems, with strong performance compared to traditional methods.
