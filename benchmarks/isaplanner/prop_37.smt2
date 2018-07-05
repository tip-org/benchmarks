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
  delete
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (_ nil Nat))
      (case (cons z xs)
        (ite (== x z) (delete x xs) (cons z (delete x xs))))))
(define-fun-rec
  elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z xs) (ite (== x z) true (elem x xs)))))
(prove
  (forall ((x Nat) (xs (list Nat))) (not (elem x (delete x xs)))))
