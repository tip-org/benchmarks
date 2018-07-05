; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  +2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (+2 z y)))))
(define-fun-rec
  mult
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case Z z)
      (case (S x2) (mult x2 y (+2 y z)))))
(define-fun-rec
  *2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (+2 y (*2 z y)))))
(prove (forall ((x Nat) (y Nat)) (= (*2 x y) (mult x y Z))))
