program main
  use config_mod
  use dualzn_mod
  implicit none

  type(dualzn) :: x

  write(*,"(A,1x,I0)") "max-order:", max_order_dualzn
  x = xto_dzn(0,1)
  
  write(*,"(A,1x,f0.5)") "xf0:",f_part(x,1)
end program main
