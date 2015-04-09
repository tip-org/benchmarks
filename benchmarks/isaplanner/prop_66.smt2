; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a2) (len ((x (list a2))) Nat)))
  ((match x
     (case nil Z)
     (case (cons ds xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((le ((x5 Nat) (x6 Nat)) bool))
  ((match x5
     (case Z true)
     (case
       (S ipv)
       (match x6
         (case Z false)
         (case (S ipv2) (le ipv ipv2)))))))
(define-funs-rec
  ((par (a3) (filter ((x2 (=> a3 bool)) (x3 (list a3))) (list a3))))
  ((match x3
     (case nil x3)
     (case
       (cons x4 xs2)
       (ite
         (@ x2 x4) (cons x4 (as (filter x2 xs2) (list a3)))
         (as (filter x2 xs2) (list a3)))))))
(assert-not
  (par
    (a4)
    (forall
      ((p2 (=> a4 bool)) (xs3 (list a4)))
      (le (len (filter p2 xs3)) (len xs3)))))
(check-sat)
