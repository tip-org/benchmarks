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
  count :source Definitions.count
    ((x Nat) (y (list Nat))) Nat
    (match y
      (case nil Z)
      (case (cons z ys) (ite (== x z) (S (count x ys)) (count x ys)))))
(define-fun-rec
  +2 :source Definitions.+
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (+2 z y)))))
(prove
  :source Properties.prop_75
  (forall ((n Nat) (m Nat) (xs (list Nat)))
    (= (+2 (count n xs) (count n (cons m (_ nil Nat))))
      (count n (cons m xs)))))
