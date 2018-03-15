; Property about natural numbers with binary presentation
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(declare-datatypes ()
  ((Bin :source BinLists.Bin (One :source BinLists.One)
     (ZeroAnd :source BinLists.ZeroAnd (proj1-ZeroAnd Bin))
     (OneAnd :source BinLists.OneAnd (proj1-OneAnd Bin)))))
(define-fun-rec
  s :source BinLists.s
    ((x Bin)) Bin
    (match x
      (case One (ZeroAnd One))
      (case (ZeroAnd xs) (OneAnd xs))
      (case (OneAnd ys) (ZeroAnd (s ys)))))
(define-fun-rec
  plus :definition :source |+|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun-rec
  toNat :source BinLists.toNat
    ((x Bin)) Nat
    (match x
      (case One (succ zero))
      (case (ZeroAnd xs) (plus (toNat xs) (toNat xs)))
      (case (OneAnd ys)
        (plus (plus (succ zero) (toNat ys)) (toNat ys)))))
(prove
  :source BinLists.prop_s
  (forall ((n Bin)) (= (toNat (s n)) (plus (succ zero) (toNat n)))))
(assert
  :axiom |associativity of +|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert
  :axiom |commutativity of +|
  (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus x zero) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus zero x) x)))
