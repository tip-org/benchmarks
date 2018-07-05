; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (takeWhile
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (_ nil a))
         (case (cons z xs)
           (ite (@ x z) (cons z (takeWhile x xs)) (_ nil a)))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (= (takeWhile (lambda ((x a)) true) xs) xs))))
