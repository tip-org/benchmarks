; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (dropWhile
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (_ nil a))
         (case (cons z xs) (ite (@ x z) (dropWhile x xs) y))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (= (dropWhile (lambda ((x a)) false) xs) xs))))
