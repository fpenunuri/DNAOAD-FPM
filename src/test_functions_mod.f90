!module with example of functions
module test_functions_mod
  use dualzn_mod
  implicit none
  private

  public :: fstest, fvectest

contains
  !Example of scalar function f = sin(x*y*z) + cos(x*y*z)
  function fstest(r) result(fr)
    type(dualzn), intent(in), dimension(:) :: r
    type(dualzn) :: fr
    type(dualzn) :: x,y,z

    x = r(1); y = r(2); z = r(3)
    fr = sin(x*y*z) + cos(x*y*z)
  end function fstest

  !Example of vector function f = [f1,f2,f3]
  !f = fvectest(r) is a function f:D^m ---> Dn 
  function fvectest(r) result(fr)
    type(dualzn), intent(in), dimension(:) :: r
    type(dualzn), allocatable, dimension(:) :: fr
    type(dualzn) :: f1,f2,f3
    type(dualzn) :: x,y,z,w

    x = r(1); y = r(2); z = r(3); w = r(4)

    f1 = sin(x*y*z*w)
    f2 = cos(x*y*z*w)*sqrt(w/y - x/z)
    f3 = sin(log(x*y*z*w))

    allocate(fr(3))
    fr = [f1,f2,f3]
  end function fvectest
end module test_functions_mod

