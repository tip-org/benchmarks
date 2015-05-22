; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (filter ((x (=> a Bool)) (y (list a))) (list a))))
  ((match y
     (case nil (as nil (list a)))
     (case (cons z xs)
       (ite (@ x z) (cons z (filter x xs)) (filter x xs))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((par (a) (rev ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (append (rev xs) (cons y (as nil (list a))))))))
(assert-not
  (par (a)
    (forall ((p (=> a Bool)) (xs (list a)))
      (= (rev (filter p xs)) (filter p (rev xs))))))
(check-sat)
