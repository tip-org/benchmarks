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
  <2 :source Definitions.<
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S x2) (<2 x2 z))))))
(define-fun-rec
  ins :source Definitions.ins
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (cons x (as nil (list Nat))))
      (case (cons z xs) (ite (<2 x z) (cons x y) (cons z (ins x xs))))))
(prove
  :source Properties.prop_15
  (forall ((x Nat) (xs (list Nat)))
    (= (len (ins x xs)) (S (len xs)))))
