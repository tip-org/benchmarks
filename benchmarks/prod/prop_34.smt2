; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  +2 :source Definitions.+
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (+2 z y)))))
(define-fun-rec
  mult :source Definitions.mult
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case Z z)
      (case (S x2) (mult x2 y (+2 y z)))))
(define-fun-rec
  *2 :source Definitions.*
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (+2 y (*2 z y)))))
(prove
  :source Properties.prop_T34
  (forall ((x Nat) (y Nat)) (= (*2 x y) (mult x y Z))))
