; Modulus, structurally recursive and straightforward implementation
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S n)
        (match y
          (case Z x)
          (case (S m) (minus n m))))))
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
  mod2
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z Z)
      (case (S z) (ite (lt x y) x (mod2 (minus x y) y)))))
(define-fun-rec
  go
    ((x Nat) (y Nat) (z Nat)) Nat
    (match z
      (case Z Z)
      (case (S x2)
        (match x
          (case Z
            (match y
              (case Z Z)
              (case (S n) (minus z y))))
          (case (S m)
            (match y
              (case Z (go m x2 z))
              (case (S k) (go m k z))))))))
(define-fun mod_structural ((x Nat) (y Nat)) Nat (go x Z y))
(assert-not
  (forall ((m Nat) (n Nat)) (= (mod2 m n) (mod_structural m n))))
(check-sat)
