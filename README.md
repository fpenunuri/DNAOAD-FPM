# DNAOAD (FPM Version)  
## Dual Numbers for Arbitrary Order Automatic Differentiation in Modern Fortran

This repository provides a [Fortran Package Manager (fpm)](https://fpm.fortran-lang.org/) compatible version of the dual number implementation for arbitrary-order automatic differentiation (DNAOAD).

⚠️ **Note:** The core code is essentially the same as in the original repository [fpenunuri/DNAOAD](https://github.com/fpenunuri/DNAOAD), with some changes for FPM compatibility. For more information, see the preprint:
📄 [arXiv:2501.04159](https://doi.org/10.48550/arXiv.2501.04159)

---

## 📁 Project Structure

- `src/` — Fortran source modules  
- `app/` — Executable programs  
- `docs/` — Documentation of module functions  
- `fpm.toml` — Project configuration file  

---

## 📦 Requirements

- A Fortran compiler (e.g., `gfortran`, `ifx`)  
- A recent version of `fpm`  

To install `fpm`, visit:  
👉 https://github.com/fortran-lang/fpm

---

## 🛠️ Building with `ifx` (default: `real64`)

From the project root:

```bash
FPM_FC=ifx fpm build
```

---

## ▶️ Running Examples

### Example 1 (default `real64`, max order = 5)

```bash
FPM_FC=ifx fpm run ex1
```

### Example 2 (requires higher order derivatives)

By default, `MAX_ORDER_DUALZN = 5`. The example `ex2` requires **at least 10**:

```bash
FPM_FC=ifx fpm run --flag "-DMAX_ORDER_DUALZN=10" ex2
```

---

## ⚙️ Using `real128` Precision

To build and run using `real128` precision:

```bash
FPM_FC=ifx fpm build --flag "-DUSE_REAL128"
```

Run `ex2` with higher derivative order:

```bash
FPM_FC=ifx fpm run --flag "-DUSE_REAL128 -DMAX_ORDER_DUALZN=10" ex2
```
