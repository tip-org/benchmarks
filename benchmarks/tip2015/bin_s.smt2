; Binary natural numbers
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes
  () ((Bin (One) (ZeroAnd (ZeroAnd_ Bin)) (OneAnd (OneAnd_ Bin)))))
(define-funs-rec
  ((s ((x2 Bin)) Bin))
  ((match x2
     (case One (ZeroAnd x2))
     (case (ZeroAnd xs3) (OneAnd xs3))
     (case (OneAnd xs4) (ZeroAnd (s xs4))))))
(define-funs-rec
  ((plus ((x3 Nat) (x4 Nat)) Nat))
  ((match x3
     (case Z x4)
     (case (S n) (S (plus n x4))))))
(define-funs-rec
  ((toNat ((x Bin)) Nat))
  ((match x
     (case One (S Z))
     (case (ZeroAnd xs) (plus (toNat xs) (toNat xs)))
     (case (OneAnd xs2) (S (plus (toNat xs2) (toNat xs2)))))))
(assert
  (not (forall ((n2 Bin)) (= (toNat (s n2)) (S (toNat n2))))))
(check-sat)
