; Modulus, structurally recursive and straightforward implementation
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z) (match y (case (succ y2) (minus z y2))))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case zero false)
      (case (succ z)
        (match x
          (case zero true)
          (case (succ n) (lt n z))))))
(define-fun-rec
  mod2
    ((x Nat) (y Nat)) Nat
    (match y
      (case zero zero)
      (case (succ z) (ite (lt x y) x (mod2 (minus x y) y)))))
(define-fun-rec
  go
    ((x Nat) (y Nat) (z Nat)) Nat
    (match z
      (case zero zero)
      (case (succ x2)
        (match x
          (case zero
            (match y
              (case zero zero)
              (case (succ x5) (minus z y))))
          (case (succ x3)
            (match y
              (case zero (go x3 x2 z))
              (case (succ x4) (go x3 x4 z))))))))
(define-fun mod_structural ((x Nat) (y Nat)) Nat (go x zero y))
(prove
  (forall ((m Nat) (n Nat)) (= (mod2 m n) (mod_structural m n))))
