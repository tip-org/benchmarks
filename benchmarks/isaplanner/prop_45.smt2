; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(define-funs-rec
  ((par (a b) (zip ((x (list a)) (y (list b))) (list (Pair2 a b)))))
  ((match x
     (case nil (as nil (list (Pair2 a b))))
     (case (cons z x2)
       (match y
         (case nil (as nil (list (Pair2 a b))))
         (case (cons x3 x4) (cons (Pair z x3) (zip x2 x4))))))))
(assert-not
  (par (a b)
    (forall ((x a) (y b) (xs (list a)) (ys (list b)))
      (= (zip (cons x xs) (cons y ys)) (cons (Pair x y) (zip xs ys))))))
(check-sat)
