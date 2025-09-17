program main
  use config_mod
  use dualzn_mod
  implicit none

  type(dualzn) :: x, y ,z
  integer :: k

  write(*,"(A,1x,I0)") "max_order_dualzn:", max_order_dualzn
  call initialize_dualzn(x,2)
  y = xto_dzn(0.0_prec,2)

  x%f(0:x%ord) = [1,2,3]
  y%f(0:y%ord) = [4,5,6,7]

  do k=0,y%ord
     write(*,*) y%f(k)
  end do
  write(*,"(A)") "----"

  z = x + xto_dzn(y,x%ord) 
  do k=0,z%ord
     write(*,*) z%f(k)
  end do
  write(*,"(A)") "----"
  
  !z = xto_dzn(x,y%ord) + y
  z = x*y
  do k=0,z%ord
     write(*,*) z%f(k)
  end do
  write(*,"(A)") "----"
    
end program main
