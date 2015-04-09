; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a2) (len ((x3 (list a2))) Nat)))
  ((match x3
     (case nil Z)
     (case (cons ds xs2) (S (as (len xs2) Nat))))))
(define-funs-rec
  ((le ((x7 Nat) (x8 Nat)) bool))
  ((match x7
     (case Z true)
     (case
       (S ipv)
       (match x8
         (case Z false)
         (case (S ipv2) (le ipv ipv2)))))))
(define-funs-rec
  ((insort ((x4 Nat) (x5 (list Nat))) (list Nat)))
  ((match x5
     (case nil (cons x4 x5))
     (case
       (cons x6 xs3)
       (ite (le x4 x6) (cons x4 x5) (cons x6 (insort x4 xs3)))))))
(define-funs-rec
  ((sort ((x (list Nat))) (list Nat)))
  ((match x
     (case nil x)
     (case (cons x2 xs) (insort x2 (sort xs))))))
(assert
  (not (forall ((xs4 (list Nat))) (= (len (sort xs4)) (len xs4)))))
(check-sat)
