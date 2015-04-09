; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x5 Nat) (x6 Nat)) Nat))
  ((match x5
     (case Z x6)
     (case (S x7) (S (plus x7 x6))))))
(define-funs-rec
  ((mult2 ((x8 Nat) (x9 Nat)) Nat))
  ((match x8
     (case Z x8)
     (case (S x10) (plus x9 (mult2 x10 x9))))))
(define-funs-rec
  ((mult ((x Nat) (x2 Nat) (x3 Nat)) Nat))
  ((match x
     (case Z x3)
     (case (S x4) (mult x4 x2 (plus x2 x3))))))
(assert
  (not
    (forall ((x11 Nat) (y Nat)) (= (mult2 x11 y) (mult x11 y Z)))))
(check-sat)
