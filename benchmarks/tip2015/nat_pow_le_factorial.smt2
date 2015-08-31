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
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
(define-fun-rec
  factorial
    ((x Nat)) Nat
    (match x
      (case Z (S Z))
      (case (S n) (mult x (factorial n)))))
(define-fun ^1 () Nat (S Z))
(define-fun-rec
  pow
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z ^1)
      (case (S m) (mult x (pow x m)))))
(assert-not
  (forall ((n Nat))
    (lt (pow (S (S Z)) (S (S (S (S n)))))
      (factorial (S (S (S (S n))))))))
(check-sat)
