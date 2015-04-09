; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a2) (qrev ((x (list a2)) (x2 (list a2))) (list a2))))
  ((match x
     (case nil x2)
     (case (cons x3 xs) (as (qrev xs (cons x3 x2)) (list a2))))))
(define-funs-rec
  ((plus ((x5 Nat) (x6 Nat)) Nat))
  ((match x5
     (case Z x6)
     (case (S x7) (S (plus x7 x6))))))
(define-funs-rec
  ((par (a3) (length ((x4 (list a3))) Nat)))
  ((match x4
     (case nil Z)
     (case (cons ds xs2) (S (as (length xs2) Nat))))))
(assert-not
  (par
    (a4)
    (forall
      ((x8 (list a4)) (y (list a4)))
      (= (length (qrev x8 y)) (plus (length x8) (length y))))))
(check-sat)
