; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a b)
    (zip
       ((x (list a)) (y (list b))) (list (pair a b))
       (match x
         (case nil (as nil (list (pair a b))))
         (case (cons z x2)
           (match y
             (case nil (as nil (list (pair a b))))
             (case (cons x3 x4) (cons (pair2 z x3) (zip x2 x4)))))))))
(assert-not
  (par (a b)
    (forall ((x a) (y b) (xs (list a)) (ys (list b)))
      (= (zip (cons x xs) (cons y ys)) (cons (pair2 x y) (zip xs ys))))))
(check-sat)
