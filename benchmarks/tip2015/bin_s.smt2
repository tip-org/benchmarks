; Property about natural numbers with binary presentation
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Bin (One) (ZeroAnd (ZeroAnd_0 Bin)) (OneAnd (OneAnd_0 Bin)))))
(define-funs-rec
  ((s ((x Bin)) Bin))
  ((match x
     (case One (ZeroAnd x))
     (case (ZeroAnd xs) (OneAnd xs))
     (case (OneAnd ys) (ZeroAnd (s ys))))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S n) (S (plus n y))))))
(define-funs-rec
  ((toNat ((x Bin)) Nat))
  ((match x
     (case One (S Z))
     (case (ZeroAnd xs) (plus (toNat xs) (toNat xs)))
     (case (OneAnd ys) (S (plus (toNat ys) (toNat ys)))))))
(assert-not (forall ((n Bin)) (= (toNat (s n)) (S (toNat n)))))
(check-sat)
