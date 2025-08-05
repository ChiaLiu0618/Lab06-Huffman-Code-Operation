# IC Lab – Lab06: Huffman Code Operation

**NYCU-EE IC LAB – Spring 2023**

## Introduction
This lab focuses on building a hardware system that generates optimal prefix codes using the Huffman coding algorithm. The project includes the design of a soft IP module (`SORT_IP.v`) for sorting character weights and a top module (`HT_TOP.v`) to construct the Huffman tree and output the Huffman codes for two specific modes.

---

## Project Description
- Implement Huffman coding for 8 predefined characters: `A, B, C, E, I, L, O, V`.
- Two modes of output:
  - `out_mode = 0`: Output Huffman code for "ILOVE"
  - `out_mode = 1`: Output Huffman code for "ICLAB"
- System must:
  1. Accept input weights and mode.
  2. Sort characters based on weights (via soft IP).
  3. Build a Huffman tree.
  4. Output Huffman code of target string.

---

## I/O Specification
### Top Design – `HT_TOP.v`
#### Inputs
| Signal      | Width | Description                            |
|-------------|-------|----------------------------------------|
| clk         | 1     | Clock signal                           |
| rst_n       | 1     | Asynchronous active-low reset          |
| in_valid    | 1     | High when input signals are valid     |
| in_weight   | 3     | Weight input for each character       |
| out_mode    | 1     | 0: output "ILOVE" / 1: output "ICLAB" |

#### Outputs
| Signal      | Width | Description                            |
|-------------|-------|----------------------------------------|
| out_valid   | 1     | High when Huffman code output is valid |
| out_code    | 1     | Output Huffman code (serially)         |

### Soft IP – `SORT_IP.v`
#### Parameters
| Parameter  | Description                         |
|------------|-------------------------------------|
| IP_WIDTH   | Number of input characters to sort  |

#### Inputs
| Signal        | Width       | Description                             |
|---------------|-------------|-----------------------------------------|
| IN_character  | IP_WIDTH*4  | Characters to be sorted (fixed order)   |
| IN_weight     | IP_WIDTH*5  | Corresponding weights                   |

#### Outputs
| Signal        | Width       | Description                             |
|---------------|-------------|-----------------------------------------|
| OUT_character | IP_WIDTH*4  | Sorted output characters                |

---

## Specifications
### General
- You must not use any DesignWare IP.
- Forbidden signal names: `*error*`, `*congratulation*`, `*latch*`, `*fail*`, `*pass*`.
- No non-synthesizable code or print/display statements in submissions.

### Top Module – `HT_TOP.v`
1. Max clock period: 20 ns (precision 0.1)
2. Latency ≤ 2000 cycles (from end of `in_valid` to start of `out_valid`)
3. Total area ≤ 2,000,000 µm²
4. Must use your own-designed `SORT_IP` in the top module
5. Inputs synchronized on **negative clock edge**
6. Outputs synchronized on **positive clock edge**
7. `out_valid` must not be high when `in_valid` is high
8. TA will check correctness and timing through synthesis reports

### Soft IP – `SORT_IP.v`
1. Must complete sorting in **1 clock cycle**
2. Must use `generate` for flexibility
3. Clock period: 20 ns
4. Use `compile_ultra`, `analyze`, `elaborate` for synthesis
5. Forbidden: lookup table sorting

---

## Simulation & Synthesis Commands
| Folder         | Description               | Command                 |
|----------------|---------------------------|-------------------------|
| `01_RTL/`      | RTL Simulation            | `./01_run_vcs_rtl`      |
| `02_SYN/`      | Synthesis                 | `./01_run_dc_shell`     |
| `03_GATE/`     | Gate-Level Simulation     | `./01_run_vcs_gate`     |
| `09_SUBMIT/`   | Submission Files          | –                       |

- Clean logs: `./09_clean`

---

## Grading Policy
| Component                  | Weight |
|----------------------------|--------|
| Function Validity          | 50%    |
| Performance (Area × Latency × Cycle time) | 30%    |
| Soft IP Function Correctness| 20%   |

- Soft IP scoring varies by IP_WIDTH (up to 8%)
- 2nd demo has 30% grade reduction

---

## Submission Checklist
Submit under `09_SUBMIT/Lab06_iclabXXX/`:
- `HT_TOP_iclabXXX.v`
- `SORT_IP_iclabXXX.v`
- `CYCLE_iclabXXX.txt`
- `syn_iclabXXX.tcl`

**Deadlines:**  
- 1st demo: 2023/10/30 (Mon) 12:00 PM  
- 2nd demo: 2023/11/01 (Wed) 12:00 PM

> ⚠️ Missing files or incorrect filenames → automatic fail or -5 points

---

## References
- [Huffman Coding – Wikipedia](https://en.wikipedia.org/wiki/Huffman_coding)

---

Let me know if you'd like to export this to a downloadable `README.md` or LaTeX file!
