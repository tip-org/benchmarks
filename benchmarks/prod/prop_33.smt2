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
  fac :source Definitions.fac
    ((x Nat)) Nat
    (match x
      (case Z (S Z))
      (case (S y) (*2 x (fac y)))))
(define-fun-rec
  qfac :source Definitions.qfac
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (qfac z (*2 x y)))))
(prove
  :source Properties.prop_T33
  (forall ((x Nat)) (= (fac x) (qfac x one))))
