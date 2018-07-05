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
(define-fun-rec
  (par (a)
    (dropWhile
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (_ nil a))
         (case (cons z xs) (ite (@ x z) (dropWhile x xs) y))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(prove
  (par (a)
    (forall ((p (=> a Bool)) (xs (list a)))
      (= (++ (takeWhile p xs) (dropWhile p xs)) xs))))
