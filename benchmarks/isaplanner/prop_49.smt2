; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (butlast :source Definitions.butlast
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y z)
           (match z
             (case nil (_ nil a))
             (case (cons x2 x3) (cons y (butlast z)))))))))
(define-fun-rec
  (par (a)
    (++ :source Definitions.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun
  (par (a)
    (butlastConcat :source Definitions.butlastConcat
       ((x (list a)) (y (list a))) (list a)
       (match y
         (case nil (butlast x))
         (case (cons z x2) (++ x (butlast y)))))))
(prove
  :source Properties.prop_49
  (par (a)
    (forall ((xs (list a)) (ys (list a)))
      (= (butlast (++ xs ys)) (butlastConcat xs ys)))))
