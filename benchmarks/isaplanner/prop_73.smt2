; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (filter :source Definitions.filter
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (_ nil a))
         (case (cons z xs)
           (ite (@ x z) (cons z (filter x xs)) (filter x xs)))))))
(define-fun-rec
  (par (a)
    (++ :source Definitions.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (rev :source Definitions.rev
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ (rev xs) (cons y (_ nil a))))))))
(prove
  :source Properties.prop_73
  (par (a)
    (forall ((p (=> a Bool)) (xs (list a)))
      (= (rev (filter p xs)) (filter p (rev xs))))))
