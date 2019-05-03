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
  <2
  ((x Nat) (y Nat)) Bool
  (match y
    ((Z false)
     ((S z)
      (match x
        ((Z true)
         ((S x2) (<2 x2 z))))))))
(define-fun-rec
  ins
  ((x Nat) (y (list Nat))) (list Nat)
  (match y
    ((nil (cons x (_ nil Nat)))
     ((cons z xs) (ite (<2 x z) (cons x y) (cons z (ins x xs)))))))
(prove
  (forall ((x Nat) (xs (list Nat)))
    (= (len (ins x xs)) (S (len xs)))))
