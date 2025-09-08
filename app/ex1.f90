! main program
program main
  use config_mod
  use dualzn_mod
  implicit none

  complex(prec) :: z0
  type(dualzn) :: r, fval
  integer, parameter :: or=5
  integer :: k
  
  z0 = (1.1_prec,2.2_prec)

  !we initialize the dual number to 0 and order 5
  !also 'call initialize_dualzn(r,or)' can be used
  !do not use 'r = 0' since "=" operator is not overloaded
  r = xto_dzn(0,or)

  !we set the 0-th and 1-th components. If dual numbers are used to
  !calculate D^n f(z0) then r must be of the form r = r0 + 1*eps_1
  r%f(0) = z0
  r%f(1) = 1.0_prec 

  fval = sin(r)**log(r*r)

  !writing the derivatives, from the 0th derivative up to the
  !order-th derivative.
  print*,"derivatives"
   do k=0, or
      print*,fval%f(k)
   end do

end program main

  
  
  
