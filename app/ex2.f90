!main program
program main
  use config_mod
  use dualzn_mod
  implicit none

  type(dualzn) :: r, fval
  integer :: k
  real :: t1,t2
  type(dualzn), dimension(3) :: vec1
  complex(prec), dimension(3) :: vec1f0, vec1f1
  complex(prec) :: z0
  integer, parameter :: or=5
  
  write(*,"(A,1x,I0)") "max-order:", max_order_dualzn

  r = xto_dzn(0,or) !<--- initializing r to 0 and order 'or'
                     !also 'call initialize_dualzn(r,or)' can be used

  r%f(0) = (1.1_prec,0.0_prec)
  r%f(1) = 1 !since we want to differentiate, r = r0 +1*eps_1
  !all the other components are 0 as r was initialized to 0

  !print*, r%f(9)
  print*, f_part(r,5)
  
  write(*,"(A)")"----"

  call cpu_time(t1)
  fval = ftest(r)
  call cpu_time(t2)
  
  !Computing the derivatives, from the 0th derivative up to the
  !or-th derivative.
  print*,"derivatives"
  do k=0, or
     write(*,"(i0,a,f0.1,a,e17.10)") k,"-th derivative at x = ", &
          real(r%f(0)),":",real(fval%f(k))
  end do

  write(*,"(A,1x,F0.5)") "elapsed time (s):",t2-t1
  write(*,"(A)")"----"
  call initialize_dualzn(vec1,1)
  
  write(*,"(A,1x,I0)") "or-vec1:",vec1(1)%ord

  z0 = (1,1)
  call f_set_part(vec1,z0,1)
  vec1f0 = f_part(vec1,0)
  vec1f1 = f_part(vec1,1)
  write(*,"(A)")"--S--"
  
  do k = 1,3
     write(*,*) vec1f0(k)
  end do
  write(*,"(A)")"----"

  do k = 1,3
     write(*,*) vec1f1(k)
  end do

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
