; Property about natural numbers with binary presentation
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Bin (One) (ZeroAnd (ZeroAnd_0 Bin)) (OneAnd (OneAnd_0 Bin)))))
(define-fun-rec
  s ((x Bin)) Bin
    (match x
      (case One (ZeroAnd One))
      (case (ZeroAnd xs) (OneAnd xs))
      (case (OneAnd ys) (ZeroAnd (s ys)))))
(define-fun-rec
  plus2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus2 n y)))))
(define-fun-rec
  toNat
    ((x Bin)) Nat
    (match x
      (case One (S Z))
      (case (ZeroAnd xs) (plus2 (toNat xs) (toNat xs)))
      (case (OneAnd ys) (S (plus2 (toNat ys) (toNat ys))))))
(define-fun-rec
  plus
    ((x Bin) (y Bin)) Bin
    (match x
      (case One (s y))
      (case (ZeroAnd z)
        (match y
          (case One (s x))
          (case (ZeroAnd ys) (ZeroAnd (plus z ys)))
          (case (OneAnd xs) (OneAnd (plus z xs)))))
      (case (OneAnd x2)
        (match y
          (case One (s x))
          (case (ZeroAnd zs) (OneAnd (plus x2 zs)))
          (case (OneAnd ys2) (ZeroAnd (s (plus x2 ys2))))))))
(define-fun-rec
  times
    ((x Bin) (y Bin)) Bin
    (match x
      (case One y)
      (case (ZeroAnd xs) (ZeroAnd (times xs y)))
      (case (OneAnd ys) (plus (ZeroAnd (times ys y)) y))))
(define-fun-rec
  mult
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S n) (plus2 y (mult n y)))))
(assert-not
  (forall ((x Bin) (y Bin))
    (= (toNat (times x y)) (mult (toNat x) (toNat y)))))
(check-sat)
