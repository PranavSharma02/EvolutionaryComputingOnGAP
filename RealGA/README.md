# Real-Coded Genetic Algorithm (RCGA) for GAP and Sphere Function Optimization

This repository contains MATLAB implementations and experimental results for solving the **Generalized Assignment Problem (GAP)** and the **Sphere optimization function** using a **Real-Coded Genetic Algorithm (RCGA)**. It includes comparisons with **Binary GA**, **Greedy**, **Optimal**, and **Approximation** methods.

---

## 🧠 Problem Overview

### 1. Generalized Assignment Problem (GAP)
GAP is a combinatorial optimization problem where a set of users needs to be assigned to a set of servers, minimizing cost or maximizing utility while respecting resource constraints.

### 2. Sphere Function Optimization
A benchmark function for evaluating real-coded optimization algorithms. The objective is to minimize the sum of squared values.

---

## 🧬 Algorithms Implemented

### ✅ Real-Coded Genetic Algorithm (RCGA)
- Chromosome: vector of real numbers \[0,1\] representing preferences.
- Selection: Tournament
- Crossover: 
- Mutation: 
- Repair: Decoding strategy ensures feasibility based on resource constraints.

### 🔲 Binary GA (BGA)
- Standard binary-encoded GA used for comparison in GAP experiments.

### 🟩 Greedy & 🟦 Optimal Solutions
- Included for benchmarking.

---

## 📊 Files and Scripts

| File | Description |
|------|-------------|
| `gapRGA-2.m` | Main RCGA implementation for GAP. Reads all 12 GAP datasets, solves them using RCGA, and writes results. |
| `compareBGAvsRGAvsOPTIvsAPP.m` | Compares performance (utility) of RCGA, BGA, Greedy, and Optimal on GAP12 dataset. Generates plots and summary CSV. |
| `gap_rcga_results.csv` | RCGA output on GAP datasets (auto-generated). |
| `gap12_avg_results.csv` | Average RCGA performance on GAP12 over multiple runs. |
| `RGAvsBGAvsAPPvsOPTI.png` | Visualization comparing all four methods on GAP12. |
| `sphereRGA.m` | RCGA optimization on Sphere function. Includes convergence plotting. |
| `sphereRGAgraph.png` | Convergence plot of Sphere function optimization. |

---

## 📈 Results

### GAP File 12:
- RCGA performance is benchmarked using utility metrics and compared to BGA, Greedy, and Optimal approaches.
- Visualization: `RGAvsBGAvsAPPvsOPTI.png`

### Sphere Function:
- Shows convergence of RCGA minimizing the Sphere function.
- Visualization: `sphereRGAgraph.png`

---

## 📦 How to Run

1. Open MATLAB.
2. Ensure all `.m` and `.csv` files are in the same directory.
3. Run GAP with RCGA:
    ```matlab
    process_large_gap_rcga
    ```
4. Compare algorithms on GAP12:
    ```matlab
    compareAllFourAlgorithms
    ```
5. Run Sphere optimization:
    ```matlab
    sphereRGA
    ```

---

## 📁 Output

- GAP comparison results: `four_algorithm_comparison.csv`
- RCGA visual comparison: `algorithm_comparison.png`
- Sphere convergence: `sphereRGAgraph.png`

---


