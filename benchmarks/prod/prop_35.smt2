; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun one :source Definitions.one () Nat (S Z))
(define-fun-rec
  +2 :source Definitions.+
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (+2 z y)))))
(define-fun-rec
  *2 :source Definitions.*
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (+2 y (*2 z y)))))
(define-fun-rec
  exp :source Definitions.exp
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S n) (*2 x (exp x n)))))
(define-fun-rec
  qexp :source Definitions.qexp
    ((x Nat) (y Nat) (z Nat)) Nat
    (match y
      (case Z z)
      (case (S n) (qexp x n (*2 x z)))))
(prove
  :source Properties.prop_T35
  (forall ((x Nat) (y Nat)) (= (exp x y) (qexp x y one))))
