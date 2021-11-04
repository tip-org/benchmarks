; Lemmas from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  +2
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z y)
     ((S z) (S (+2 z y))))))
(define-fun-rec
  *2
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z Z)
     ((S z) (+2 y (*2 z y))))))
(prove
  (forall ((x Nat) (y Nat) (z Nat))
    (= (*2 (*2 x y) z) (*2 x (*2 y z)))))
