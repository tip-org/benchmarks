; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  min :source Definitions.min
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z Z)
          (case (S y1) (S (min z y1)))))))
(prove
  :source Properties.prop_31
  (forall ((a Nat) (b Nat) (c Nat))
    (= (min (min a b) c) (min a (min b c)))))
