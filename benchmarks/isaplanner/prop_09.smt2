; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  |-2|
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z Z)
     ((S z)
      (match y
        ((Z x)
         ((S x2) (|-2| z x2))))))))
(define-fun-rec
  +2
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z y)
     ((S z) (S (+2 z y))))))
(prove
  (forall ((i Nat) (j Nat) (k Nat))
    (= (|-2| (|-2| i j) k) (|-2| i (+2 j k)))))
