# DNAOAD Package
*A Fortran implementation of dual numbers for arbitrary-order automatic differentiation*

---

## A. `module config_mode`
This module defines:
- The preprocessor parameter `prec` for `real64` and `real128` precision.  
- The parameter `max_order_dualzn = MAX_ORDER_DUALZN`, which by default is set to **5**.

---

## B. `module dualzn_mod`
This module provides the **core implementation** of dual numbers.

### I. Definition of the dual number type
```fortran
type, public :: dualzn
  complex(prec), dimension(0:max_order_dualzn) :: f
  integer :: ord
end type dualzn
```

- `max_order_dualzn` specifies the maximum derivative order supported.  
  - In practice, derivatives beyond the 4th order are rarely required.  
  - Higher orders are theoretically possible but may suffer from numerical precision issues.  

- `f(n)` stores the *n*-th coefficient of the dual number.  
- `ord` stores the current order of the dual number, with `0 <= ord <= max_order_dualzn`.  

> ⚠️ **Note:** Accessing `f(n)` with `ord < n < max_order_dualzn` is technically possible, but such values are either zero or undefined. Instead, use `f_part` and `f_set_part`.

### Overloaded operators
```
==, /=, +, -, *, /, **
```
Intrinsic assignment (`=`) is **not overloaded**. Fortran already supports assignment between identical types . For cross-type conversions, use explicit constructors or functions.

Example:
```fortran
d = xto_dzn(x, n)
```

Rationale:
- Overloading assignment may introduce ambiguities.  
- Explicit conversion ensures clarity and predictability.

---

### II. Core constructors and utilities

#### 1. `subroutine initialize_dualzn(zdn, n)`
Initializes a dual number of order `n`.  
- Sets `ord` and zeroes `f(0:n)`.  
- Coefficients beyond `n` remain undefined.

Usage:
```fortran
call initialize_dualzn(z, n)   ! scalar
call initialize_dualzn(Z, n)   ! array, elementwise
```

#### 2. `function f_part(x, k)`
Returns the coefficient `f(k)` of a dual number (scalar or array).  
Safer than direct access `x%f(k)`.

Usage:
```fortran
fr = f_part(x, k)   ! scalar
fr = f_part(X, k)   ! array, elementwise
```

#### 3. `subroutine f_set_part(x, y, k)`
Assigns the coefficient `f(k)` of a dual number (scalar or array).

Usage:
```fortran
call f_set_part(x, y, k)   ! scalar
call f_set_part(X, y, k)   ! array, elementwise
```

#### 4. `function xto_dzn(X, n)`
Constructs and returns a new `dualzn` of order `n` from `X` (does not modify `X`).


Example (coefficients shown as arrays):
```fortran
X(0:2) = [0, 1, 2]   ! dualzn of order 2
Y = xto_dzn(X, 1)    ! --> [0, 1]
Y = xto_dzn(X, 4)    ! --> [0, 1, 2, 0, 0]
Y = xto_dzn(0, 3)    ! --> [0, 0, 0, 0]
```

#### 5. `function xto_complex(X)`
Returns a new `complex(prec)` value constructed from `X`. The argument `X` is unchanged.


Usage:
```fortran
fr = xto_complex(X)
```

---

### III. Mathematical functions
The following **elemental, intrinsic-like** functions are overloaded:

`sin, cos, tan, exp, log, sqrt, asin, acos, atan, asinh, acosh, atanh, sinh, cosh, tanh, atan2, conjg`  

Additional functions:  
- `inv(r) = 1/r`  
- `absx(r) = sqrt(r*r)`  

---

### IV. Array and matrix operations
- `matmul(A, B)` → both arguments must be rank-2 arrays.  
- `sum(A)` or `sum(A, direction)`  
- `product(A)` or `product(A, direction)`  

---

## C. `module diff_mod`
*(work in progress)*

---

## D. `module test_functions_mod`
*(work in progress)*

---
