; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  take
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((Z (_ nil a))
     ((S z)
      (match y
        ((nil (_ nil a))
         ((cons x2 x3) (cons x2 (take z x3)))))))))
(define-fun-rec
  map
  (par (a b) (((x (=> a b)) (y (list a))) (list b)))
  (match y
    ((nil (_ nil b))
     ((cons z xs) (cons (@ x z) (map x xs))))))
(prove
  (par (a b)
    (forall ((n Nat) (f (=> a b)) (xs (list a)))
      (= (take n (map f xs)) (map f (take n xs))))))
