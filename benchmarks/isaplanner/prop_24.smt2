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
(define-fun-rec
  ==
  ((x Nat) (y Nat)) Bool
  (match x
    ((Z
      (match y
        ((Z true)
         ((S z) false))))
     ((S x2)
      (match y
        ((Z false)
         ((S y2) (== x2 y2))))))))
(define-fun-rec
  <=2
  ((x Nat) (y Nat)) Bool
  (match x
    ((Z true)
     ((S z)
      (match y
        ((Z false)
         ((S x2) (<=2 z x2))))))))
(prove (forall ((a Nat) (b Nat)) (= (== (max a b) a) (<=2 b a))))
