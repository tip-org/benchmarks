; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x11 Nat) (x12 Nat)) bool))
  ((match x11
     (case Z true)
     (case
       (S ipv2)
       (match x12
         (case Z false)
         (case (S ipv3) (le ipv2 ipv3)))))))
(define-funs-rec
  ((insert2 ((x3 Nat) (x4 (list Nat))) (list Nat)))
  ((match x4
     (case nil (cons x3 x4))
     (case
       (cons x5 xs2)
       (ite (le x3 x5) (cons x3 x4) (cons x5 (insert2 x3 xs2)))))))
(define-funs-rec
  ((isort ((x (list Nat))) (list Nat)))
  ((match x
     (case nil x)
     (case (cons x2 xs) (insert2 x2 (isort xs))))))
(define-funs-rec
  ((equal ((x9 Nat) (x10 Nat)) bool))
  ((match x9
     (case
       Z
       (match x10
         (case Z true)
         (case (S ipv) false)))
     (case
       (S ds)
       (match x10
         (case Z false)
         (case (S y) (equal ds y)))))))
(define-funs-rec
  ((count ((x6 Nat) (x7 (list Nat))) Nat))
  ((match x7
     (case nil Z)
     (case
       (cons x8 xs3)
       (ite (equal x6 x8) (S (count x6 xs3)) (count x6 xs3))))))
(assert
  (not
    (forall
      ((x13 Nat) (y2 (list Nat)))
      (= (count x13 (isort y2)) (count x13 y2)))))
(check-sat)
