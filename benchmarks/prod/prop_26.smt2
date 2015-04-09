; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x3 Nat) (x4 Nat)) Nat))
  ((match x3
     (case Z x4)
     (case (S x5) (S (plus x5 x4))))))
(define-funs-rec
  ((half ((x Nat)) Nat))
  ((match x
     (case Z x)
     (case
       (S ds)
       (match ds
         (case Z ds)
         (case (S x2) (S (half x2))))))))
(assert-not
  (forall
    ((x6 Nat) (y Nat)) (= (half (plus x6 y)) (half (plus y x6)))))
(check-sat)
