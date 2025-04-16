
# 🧮 Generalized Assignment Problem Solver (GAP) - MATLAB

This project provides a complete solution for the **Generalized Assignment Problem (GAP)** using MATLAB’s `intlinprog` solver to find the **optimal assignment**. It processes a set of predefined dataset files, solves each instance using Integer Linear Programming (ILP), and outputs the results into a structured CSV file.

---

## 📂 Project Structure

```
📁 project/
├── tryOptimal.m                # Main MATLAB script
├── gap dataset files/         # Folder containing dataset files gap1.txt to gap12.txt
│   ├── gap1.txt
│   ├── ...
│   └── gap12.txt
└── gap_max_results.csv        # Output CSV file with utility results (generated after running)
```

---

## 🚀 How to Run

1. Ensure the dataset files `gap1.txt` to `gap12.txt` are located inside a folder named: `gap dataset files/`
2. Open MATLAB and set your current folder to the project directory
3. Run the script:
   ```matlab
   processDataFiles();
   ```
4. After execution, results are saved to:
   ```
   gap_max_results.csv
   ```

---

## 📌 Output Format (`gap_max_results.csv`)

| FileIndex | InstanceName | Utility |
|-----------|--------------|---------|
| 1         | c500-1       | 1042    |
| 1         | c500-2       | 986     |
| ...       | ...          | ...     |

- **FileIndex**: Refers to the dataset file (`gap1.txt` → 1, `gap2.txt` → 2, etc.)
- **InstanceName**: Unique identifier (format: `c<serverUser>-<caseIndex>`)
- **Utility**: Optimal utility value from solving the assignment

---

## ⚙️ Solver Details

- Solved using MATLAB’s `intlinprog` (Mixed-Integer Linear Programming)
- Decision variables: Binary assignment matrix
- Constraints:
  - Each user is assigned to exactly one server
  - Server capacity must not be exceeded
- Objective: Maximize total utility

---

## 📈 Display Format in Console

The script also prints results grouped by dataset in a side-by-side format:

```
gap1            gap2            gap3            gap4            
c500-1  1042    c500-1  1021    c500-1  998     c500-1  1003
c500-2  986     c500-2  999     c500-2  972     c500-2  978
...
```

---

## 🧩 Dependencies

- MATLAB R2019b or newer
- Optimization Toolbox (`intlinprog` required)



