# DNAOAD-FPM Package
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

> ⚠️ **Note:** Accessing `f(n)` with `ord < n <= max_order_dualzn` is technically possible, but such values are either zero or undefined. Instead, use `f_part` and `f_set_part`.

### Overloaded operators
```
==, /=, +, -, *, /, **
```
Intrinsic assignment (`=`) is **not overloaded**. Fortran already supports assignment between identical types . For cross-type conversions, use the xto_dzn function.

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
X%f(0:2) = [0, 1, 2]  ! dualzn of order 2
Y = xto_dzn(X, 1)     ! --> [0, 1]
Y = xto_dzn(X, 4)     ! --> [0, 1, 2, 0, 0]
Y = xto_dzn(0, 3)     ! --> [0, 0, 0, 0]
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
This module contains some directional derivatives and differential operators.

### Interfaces

I. **`fsdual`**: Abstract interface for a scalar dual function  
   \( f:\mathbb{D}^m \to \mathbb{D} \)  
   ```fortran
   abstract interface
      function fsdual(xd) result(frsd)
        use dualzn_mod
        type(dualzn), intent(in), dimension(:) :: xd
        type(dualzn) :: frsd
      end function fsdual
   end interface
   ```

II. **`fvecdual`**: Abstract interface for a vector dual function  
   \( f:\mathbb{D}^m \to \mathbb{D}^n \)  
   ```fortran
   abstract interface
      function fvecdual(xd) result(frd)
        use dualzn_mod
        type(dualzn), intent(in), dimension(:)  :: xd
        type(dualzn), allocatable, dimension(:) :: frd
      end function fvecdual
   end interface
   ```

### Functions

1. **`dfv = d1fscalar(fsd,v,q)`**  
   - Returns: `complex(prec)`  
   - First-order directional derivative of a scalar function along vector `v`, evaluated at point `q`.  
   - `fsd`: procedure(fsdual). A scalar dualzn function \( f:\mathbb{D}^m \to \mathbb{D} \).  
   - `v`: `complex(prec), dimension(:)`. Direction vector.  

2. **`d2fv = d2fscalar(fsd,v,q)`**  
   - Returns: `complex(prec)`  
   - Second-order directional derivative along vector `v`, at point `q`.  
   - Equivalent to **v.H.v** (Hessian with vector `v`) but more efficient.  

3. **`d2fv = d2fscalar(fsd,u,v,q)`**  
   - Returns: `complex(prec)`  
   - Second-order directional derivative along vectors `u`, `v`, at point `q`.  
   - Equivalent to **u.H.v** (Hessian with vectors `u`, `v`) but more efficient.  

4. **`dfvecv = d1fvector(fvecd,v,q,n)`**  
   - Returns: `complex(prec), dimension(n)`  
   - First-order directional derivative of a vector function along vector `v`, evaluated at `q`.  
   - Equivalent to **J.v** (Jacobian with vector `v`) but more efficient.  

5. **`H = Hessian(fsd,q)`**  
   - Returns: `complex(prec), dimension(size(q),size(q))`  
   - Computes the Hessian matrix of a scalar function at point `q`.  

6. **`J = Jacobian(fvecd,q,n)`**  
   - Returns: `complex(prec), dimension(n,size(q))`  
   - Computes the Jacobian matrix of a vector function at point `q`.  

7. **`G = gradient(fsd,q)`**  
   - Returns: `complex(prec), dimension(size(q))`  
   - Computes the gradient vector of a scalar function at point `q`.  


---
## D. `module test_functions_mod`
This module provides examples of two types of functions:  
- a scalar function defined on a vector variable, and  
- a vector function defined on vector variables.  

These are used in example **ex3**.

---
