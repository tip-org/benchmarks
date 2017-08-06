; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
;
; This property is the same as prod #48
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
  <=2 :source Definitions.<=
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (<=2 z x2))))))
(define-fun-rec
  insort :source Definitions.insort
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (cons x (_ nil Nat)))
      (case (cons z xs)
        (ite (<=2 x z) (cons x y) (cons z (insort x xs))))))
(define-fun-rec
  sort :source Definitions.sort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons y xs) (insort y (sort xs)))))
(prove
  :source Properties.prop_20
  (forall ((xs (list Nat))) (= (len (sort xs)) (len xs))))
