; Property about natural numbers with binary presentation
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Bin (One) (ZeroAnd (ZeroAnd_0 Bin)) (OneAnd (OneAnd_0 Bin)))))
(define-funs-rec
  ((s ((x Bin)) Bin))
  ((match x
     (case One (ZeroAnd One))
     (case (ZeroAnd xs) (OneAnd xs))
     (case (OneAnd ys) (ZeroAnd (s ys))))))
(define-funs-rec
  ((plus2 ((x Bin) (y Bin)) Bin))
  ((match x
     (case One (s y))
     (case (ZeroAnd z)
       (match y
         (case One (s x))
         (case (ZeroAnd ys) (ZeroAnd (plus2 z ys)))
         (case (OneAnd xs) (OneAnd (plus2 z xs)))))
     (case (OneAnd x2)
       (match y
         (case One (s x))
         (case (ZeroAnd zs) (OneAnd (plus2 x2 zs)))
         (case (OneAnd ys2) (ZeroAnd (s (plus2 x2 ys2)))))))))
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
(assert-not
  (forall ((x Bin) (y Bin))
    (= (toNat (plus2 x y)) (plus (toNat x) (toNat y)))))
(check-sat)
