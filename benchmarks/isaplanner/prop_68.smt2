; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (len :source Definitions.len
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (len xs)))))))
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
  <=2 :source Definitions.<=
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (<=2 z x2))))))
(prove
  :source Properties.prop_68
  (forall ((n Nat) (xs (list Nat)))
    (<=2 (len (delete n xs)) (len xs))))
