!main program
program main
  use config_mod
  use dualzn_mod
  implicit none

  type(dualzn) :: r, fval
  integer :: k
  real :: t1,t2
  integer, parameter :: or=10
  
  write(*,"(A,1x,I0)") "max-order:", max_order_dualzn
  write(*,"(A)") "----"

  r = xto_dzn(0,or) !<--- initializing r to 0 and order 'or'
                     !also 'call initialize_dualzn(r,or)' can be used

  r%f(0) = (1.1_prec,0.0_prec)
  r%f(1) = 1 !since we want to differentiate, r = r0 +1*eps_1
  !all the other components are 0 as r was initialized to 0

  
  call cpu_time(t1)
  fval = ftest(r)
  call cpu_time(t2)
  
  !Computing the derivatives, from the 0th derivative up to the
  !or-th derivative.
   write(*,"(A)") "derivatives"
  do k=0, or
     write(*,"(i0,a,f0.1,a,e17.10)") k,"-th derivative at x = ", &
          real(r%f(0)),":",real(fval%f(k))
  end do

  write(*,"(A,1x,F0.5)") "elapsed time (s):",t2-t1

contains
  function ftest(x) result(fr)
    type(dualzn), intent(in) :: x
    type(dualzn) :: fr
    integer :: k

    !nested function f(x) = sin(x) * exp(-x^2), f(f(...(f(x))...))
    !applied 1000 times
    fr = sin(x)*exp(-x*x)
    do k=1, 1000-1
       fr = sin(fr)*exp(-fr*fr)
    end do
  end function ftest
end program main
