; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  zip
  (par (a b) (((x (list a)) (y (list b))) (list (pair a b))))
  (match x
    ((nil (_ nil (pair a b)))
     ((cons z x2)
      (match y
        ((nil (_ nil (pair a b)))
         ((cons x3 x4) (cons (pair2 z x3) (zip x2 x4)))))))))
(define-fun
  zipConcat
  (par (a b) (((x a) (y (list a)) (z (list b))) (list (pair a b))))
  (match z
    ((nil (_ nil (pair a b)))
     ((cons y2 ys) (cons (pair2 x y2) (zip y ys))))))
(prove
  (par (a b)
    (forall ((x a) (xs (list a)) (ys (list b)))
      (= (zip (cons x xs) ys) (zipConcat x xs ys)))))
