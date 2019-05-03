; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  len
  (par (a) (((x (list a))) Nat))
  (match x
    ((nil Z)
     ((cons y xs) (S (len xs))))))
(define-fun-rec
  filter
  (par (a) (((x (=> a Bool)) (y (list a))) (list a)))
  (match y
    ((nil (_ nil a))
     ((cons z xs) (ite (@ x z) (cons z (filter x xs)) (filter x xs))))))
(define-fun-rec
  <=2
  ((x Nat) (y Nat)) Bool
  (match x
    ((Z true)
     ((S z)
      (match y
        ((Z false)
         ((S x2) (<=2 z x2))))))))
(prove
  (par (a)
    (forall ((p (=> a Bool)) (xs (list a)))
      (<=2 (len (filter p xs)) (len xs)))))
