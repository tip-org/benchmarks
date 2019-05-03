; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  takeWhile
  (par (a) (((x (=> a Bool)) (y (list a))) (list a)))
  (match y
    ((nil (_ nil a))
     ((cons z xs) (ite (@ x z) (cons z (takeWhile x xs)) (_ nil a))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (= (takeWhile (lambda ((x a)) true) xs) xs))))
