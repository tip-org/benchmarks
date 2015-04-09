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
  ((le ((x7 Nat) (x8 Nat)) bool))
  ((match x7
     (case Z true)
     (case
       (S ipv2)
       (match x8
         (case Z false)
         (case (S ipv3) (le ipv2 ipv3)))))))
(define-funs-rec
  ((equal ((x5 Nat) (x6 Nat)) bool))
  ((match x5
     (case
       Z
       (match x6
         (case Z true)
         (case (S ipv) false)))
     (case
       (S ds2)
       (match x6
         (case Z false)
         (case (S y) (equal ds2 y)))))))
(define-funs-rec
  ((delete ((x2 Nat) (x3 (list Nat))) (list Nat)))
  ((match x3
     (case nil x3)
     (case
       (cons x4 xs2)
       (ite (equal x2 x4) (delete x2 xs2) (cons x4 (delete x2 xs2)))))))
(assert
  (not
    (forall
      ((n Nat) (xs3 (list Nat))) (le (len (delete n xs3)) (len xs3)))))
(check-sat)
