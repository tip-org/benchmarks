; Property about natural numbers with binary presentation
(declare-datatype Nat ((zero) (succ (p Nat))))
(declare-datatype
  Bin
  ((One) (ZeroAnd (proj1-ZeroAnd Bin)) (OneAnd (proj1-OneAnd Bin))))
(define-fun-rec
  s
  ((x Bin)) Bin
  (match x
    ((One (ZeroAnd One))
     ((ZeroAnd xs) (OneAnd xs))
     ((OneAnd ys) (ZeroAnd (s ys))))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
(define-fun-rec
  toNat
  ((x Bin)) Nat
  (match x
    ((One (succ zero))
     ((ZeroAnd xs) (plus (toNat xs) (toNat xs)))
     ((OneAnd ys) (plus (plus (succ zero) (toNat ys)) (toNat ys))))))
(prove
  (forall ((n Bin)) (= (toNat (s n)) (plus (succ zero) (toNat n)))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
