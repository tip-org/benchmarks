; Property about the power function over naturals.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(define-fun-rec
  mult
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S n) (plus y (mult n y)))))
(define-fun ^1 () Nat (S Z))
(define-fun-rec
  pow
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z ^1)
      (case (S m) (mult x (pow x m)))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (pow x (mult y z)) (pow (pow x y) z))))
(check-sat)
