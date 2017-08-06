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
(define-fun-rec
  (par (a)
    (dropWhile :source Definitions.dropWhile
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (as nil (list a)))
         (case (cons z xs) (ite (@ x z) (dropWhile x xs) y))))))
(define-fun-rec
  (par (a)
    (++ :source Definitions.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(prove
  :source Properties.prop_43
  (par (a)
    (forall ((p (=> a Bool)) (xs (list a)))
      (= (++ (takeWhile p xs) (dropWhile p xs)) xs))))
