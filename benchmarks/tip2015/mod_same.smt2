; Modulus, structurally recursive and straightforward implementation
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  minus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero zero)
     ((succ z)
      (match y
        (((succ y2) (minus z y2))
         (zero x)))))))
(define-fun-rec
  lt
  ((x Nat) (y Nat)) Bool
  (match y
    ((zero false)
     ((succ z)
      (match x
        ((zero true)
         ((succ n) (lt n z))))))))
(define-fun-rec
  mod2
  ((x Nat) (y Nat)) Nat
  (match y
    ((zero zero)
     ((succ z) (ite (lt x y) x (mod2 (minus x y) y))))))
(define-fun-rec
  go
  ((x Nat) (y Nat) (z Nat)) Nat
  (match z
    ((zero zero)
     ((succ x2)
      (match x
        ((zero
          (match y
            ((zero zero)
             ((succ x3) (minus z y)))))
         ((succ x4)
          (match y
            ((zero (go x4 x2 z))
             ((succ x5) (go x4 x5 z)))))))))))
(define-fun
  mod_structural
  ((x Nat) (y Nat)) Nat (go x zero y))
(prove
  (forall ((m Nat) (n Nat)) (= (mod2 m n) (mod_structural m n))))
