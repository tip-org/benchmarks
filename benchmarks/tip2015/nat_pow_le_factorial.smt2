; 2^n < n! for n > 3
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
(define-fun-rec
  pow
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S m) (mult x (pow x m)))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (lt z x2))))))
(define-fun-rec
  factorial
    ((x Nat)) Nat
    (match x
      (case Z (S Z))
      (case (S n) (mult x (factorial n)))))
(assert-not
  (forall ((n Nat))
    (lt (pow (S (S Z)) (S (S (S (S n)))))
      (factorial (S (S (S (S n))))))))
(check-sat)
