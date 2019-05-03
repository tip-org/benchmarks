; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  filter
  (par (a) (((x (=> a Bool)) (y (list a))) (list a)))
  (match y
    ((nil (_ nil a))
     ((cons z xs) (ite (@ x z) (cons z (filter x xs)) (filter x xs))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(prove
  (par (a)
    (forall ((p (=> a Bool)) (xs (list a)) (ys (list a)))
      (= (filter p (++ xs ys)) (++ (filter p xs) (filter p ys))))))
