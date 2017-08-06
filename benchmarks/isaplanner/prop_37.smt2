; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  == :source Definitions.==
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
  delete :source Definitions.delete
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (as nil (list Nat)))
      (case (cons z xs)
        (ite (== x z) (delete x xs) (cons z (delete x xs))))))
(define-fun-rec
  elem :source Definitions.elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z xs) (ite (== x z) true (elem x xs)))))
(prove
  :source Properties.prop_37
  (forall ((x Nat) (xs (list Nat))) (not (elem x (delete x xs)))))
