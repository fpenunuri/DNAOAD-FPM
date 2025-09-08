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
  complex(prec), dimension(3,3) :: Hmat, Hmat_t
  complex(prec), dimension(3) :: auxvec
  complex(prec) :: dir_der
  integer :: i, k
  integer, parameter :: kmax = 1e3
  real :: t1, t2
  
  vec = [1.0_prec,2.0_prec,3.0_prec,4.0_prec]
  q = vec/10.0_prec + ii
  
  print*,"---Hessian matrix---"

  call cpu_time(t1)
  do k=1,kmax
     Hmat = Hessian(fstest,q(1:3))
  end do
  call cpu_time(t2)
  write(*,"(A,1x,F0.5)") "time:",t2-t1  
  
  do i=1,3
     write(*,"(A,i0)") "row:",i
     auxvec = Hmat(i,:)
     write(*,*) auxvec
  end do
  write(*,*)

  print*,"---Hessian matrix test---"

  call cpu_time(t1)
  do k=1,kmax
     Hmat_t = Hessian_test(fstest,q(1:3))
  end do
  call cpu_time(t2)
  write(*,"(A,1x,F0.5)") "time_t:",t2-t1

  do i=1,3
     write(*,"(A,i0)") "row:",i
     auxvec = Hmat_t(i,:)
     write(*,*) auxvec
  end do
  write(*,*)

  print*,sum(Hmat - Hmat_t)
  
end program main
