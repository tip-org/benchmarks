; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  max
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z y)
     ((S z)
      (match y
        ((Z x)
         ((S x2) (S (max z x2)))))))))
(prove
  (forall ((a Nat) (b Nat) (c Nat))
    (= (max (max a b) c) (max a (max b c)))))
