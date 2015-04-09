; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x6 Nat) (x7 Nat)) Nat))
  ((match x6
     (case Z x7)
     (case (S x8) (S (plus x8 x7))))))
(define-funs-rec ((one () Nat)) ((S Z)))
(define-funs-rec
  ((mult ((x9 Nat) (x10 Nat)) Nat))
  ((match x9
     (case Z x9)
     (case (S x11) (plus x10 (mult x11 x10))))))
(define-funs-rec
  ((qexp ((x Nat) (x2 Nat) (x3 Nat)) Nat))
  ((match x2
     (case Z x3)
     (case (S n) (qexp x n (mult x x3))))))
(define-funs-rec
  ((exp ((x4 Nat) (x5 Nat)) Nat))
  ((match x5
     (case Z (S x5))
     (case (S n2) (mult x4 (exp x4 n2))))))
(assert-not
  (forall ((x12 Nat) (y Nat)) (= (exp x12 y) (qexp x12 y one))))
(check-sat)
