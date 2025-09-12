program main
  use config_mod
  use dualzn_mod
  implicit none

  type(dualzn) :: x, y ,z
  integer :: k
  
  call initialize_dualzn(x,2)
  y = xto_dzn(0.0_prec,3)

  x%f(0:x%ord) = [1,2,3]
  y%f(0:y%ord) = [4,5,6]

  z = y**x

  do k=0,z%ord
     write(*,*) z%f(k)
  end do
  write(*,"(A)") "----"
  
  
  
end program main
