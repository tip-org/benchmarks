; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  min
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z Z)
     ((S z)
      (match y
        ((Z Z)
         ((S y1) (S (min z y1)))))))))
(prove (forall ((a Nat) (b Nat)) (= (min a b) (min b a))))
