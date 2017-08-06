; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  |-2| :source Definitions.-
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (|-2| z x2))))))
(prove
  :source Properties.prop_79
  (forall ((m Nat) (n Nat) (k Nat))
    (= (|-2| (|-2| (S m) n) (S k)) (|-2| (|-2| m n) k))))
