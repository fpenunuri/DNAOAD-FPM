!main program
program main
  use config_mod
  use dualzn_mod
  use diff_mod
  use test_functions_mod
  implicit none

  integer, parameter :: nf =3, mq = 4
  complex(prec), parameter :: ii = (0,1)
  complex(prec), dimension(mq) :: q, vec
  complex(prec), dimension(nf,mq) :: Jmat
  complex(prec), dimension(nf) :: JV
  complex(prec), dimension(3) :: GV
  complex(prec), dimension(3,3) :: Hmat
  complex(prec), dimension(3) :: auxvec
  complex(prec) :: dir_der
  integer :: i
  
  vec = [1.0_prec,2.0_prec,3.0_prec,4.0_prec]
  q = vec/10.0_prec + ii

  print*,"---Gradient---"
  GV = gradient(fstest,q(1:3))
  do i=1,3
     write(*,*) GV(i)
  end do
  
  print*,"Jv using matmul"
  Jmat = Jacobian(fvectest, q , nf)
  JV = matmul(Jmat,vec)  
  do i=1,nf
     write(*,*) JV(i)
  end do
  write(*,*)

  !more efficient
  print*,"Jv using vector directional derivative"
  JV = d1fvector(fvectest,vec,q,nf)
  do i=1,nf
     write(*,*) JV(i)
  end do
  write(*,*)

  print*,"---Hessian matrix---"
  Hmat = Hessian(fstest,q(1:3))   
  do i=1,3
     write(*,"(A,i0)") "row:",i
     auxvec = Hmat(i,:)
     write(*,*) auxvec
  end do
  write(*,*)

  write(*,*) "--- directional derivative using <direction|grad> ---"
  auxvec = vec(1:3) + ii
  write(*,*) sum(auxvec*GV)
  write(*,*) dot_product(conjg(auxvec),GV)

  !more efficient
  write(*,*) "--- directional derivative ---"
  dir_der = d1fscalar(fstest,auxvec,q(1:3))
  write(*,*) dir_der
  write(*,"(A,1x,I0)") "max-order:", max_order_dualzn
end program main
