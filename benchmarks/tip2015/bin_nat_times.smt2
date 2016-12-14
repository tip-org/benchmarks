; Property about natural numbers with binary presentation
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Bin (One)
     (ZeroAnd (proj1-ZeroAnd Bin)) (OneAnd (proj1-OneAnd Bin)))))
(define-fun-rec
  s ((x Bin)) Bin
    (match x
      (case One (ZeroAnd One))
      (case (ZeroAnd xs) (OneAnd xs))
      (case (OneAnd ys) (ZeroAnd (s ys)))))
(define-fun-rec
  plus2
    ((x Bin) (y Bin)) Bin
    (match x
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
          (case (OneAnd ys2) (ZeroAnd (s (plus2 x2 ys2))))))))
(define-fun-rec
  times
    ((x Bin) (y Bin)) Bin
    (match x
      (case One y)
      (case (ZeroAnd xs1) (ZeroAnd (times xs1 y)))
      (case (OneAnd xs12) (plus2 (ZeroAnd (times xs12 y)) y))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  times2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (plus y (times2 z y)))))
(define-fun-rec
  toNat
    ((x Bin)) Nat
    (match x
      (case One (S Z))
      (case (ZeroAnd xs) (plus (toNat xs) (toNat xs)))
      (case (OneAnd ys) (plus (plus (S Z) (toNat ys)) (toNat ys)))))
(assert-not
  (forall ((x Bin) (y Bin))
    (= (toNat (times x y)) (times2 (toNat x) (toNat y)))))
(check-sat)
