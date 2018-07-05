; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  ==
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (== x2 y2))))))
(define-fun-rec
  count
    ((x Nat) (y (list Nat))) Nat
    (match y
      (case nil Z)
      (case (cons z ys) (ite (== x z) (S (count x ys)) (count x ys)))))
(prove
  (forall ((n Nat) (x Nat) (xs (list Nat)))
    (=> (= n x) (= (S (count n xs)) (count n (cons x xs))))))
