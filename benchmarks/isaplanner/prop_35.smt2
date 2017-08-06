; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (dropWhile :source Definitions.dropWhile
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (as nil (list a)))
         (case (cons z xs) (ite (@ x z) (dropWhile x xs) y))))))
(prove
  :source Properties.prop_35
  (par (a)
    (forall ((xs (list a)))
      (= (dropWhile (lambda ((x a)) false) xs) xs))))
