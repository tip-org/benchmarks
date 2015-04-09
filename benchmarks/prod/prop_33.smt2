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
  ((qfac ((x Nat) (x2 Nat)) Nat))
  ((match x
     (case Z x2)
     (case (S x3) (qfac x3 (mult x x2))))))
(define-funs-rec
  ((fac ((x4 Nat)) Nat))
  ((match x4
     (case Z (S x4))
     (case (S x5) (mult x4 (fac x5))))))
(assert (not (forall ((x12 Nat)) (= (fac x12) (qfac x12 one)))))
(check-sat)
