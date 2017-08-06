; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (takeWhile :source Definitions.takeWhile
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (as nil (list a)))
         (case (cons z xs)
           (ite (@ x z) (cons z (takeWhile x xs)) (as nil (list a))))))))
(prove
  :source Properties.prop_36
  (par (a)
    (forall ((xs (list a)))
      (= (takeWhile (lambda ((x a)) true) xs) xs))))
