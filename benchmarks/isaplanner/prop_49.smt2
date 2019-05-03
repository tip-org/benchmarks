; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  butlast
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y z)
      (match z
        ((nil (_ nil a))
         ((cons x2 x3) (cons y (butlast z)))))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun
  butlastConcat
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match y
    ((nil (butlast x))
     ((cons z x2) (++ x (butlast y))))))
(prove
  (par (a)
    (forall ((xs (list a)) (ys (list a)))
      (= (butlast (++ xs ys)) (butlastConcat xs ys)))))
