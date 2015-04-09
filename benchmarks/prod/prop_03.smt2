; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x5 Nat) (x6 Nat)) Nat))
  ((match x5
     (case Z x6)
     (case (S x7) (S (plus x7 x6))))))
(define-funs-rec
  ((par (a2) (length ((x (list a2))) Nat)))
  ((match x
     (case nil Z)
     (case (cons ds xs) (S (as (length xs) Nat))))))
(define-funs-rec
  ((par (a3) (append ((x2 (list a3)) (x3 (list a3))) (list a3))))
  ((match x2
     (case nil x3)
     (case (cons x4 xs2) (cons x4 (as (append xs2 x3) (list a3)))))))
(declare-sort a4 0)
(assert
  (not
    (forall
      ((x8 (list a4)) (y (list a4)))
      (= (length (append x8 y)) (plus (length y) (length x8))))))
(check-sat)
