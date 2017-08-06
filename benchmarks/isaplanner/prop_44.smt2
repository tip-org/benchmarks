; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a b)
    (zip :source Definitions.zip
       ((x (list a)) (y (list b))) (list (pair a b))
       (match x
         (case nil (as nil (list (pair a b))))
         (case (cons z x2)
           (match y
             (case nil (as nil (list (pair a b))))
             (case (cons x3 x4) (cons (pair2 z x3) (zip x2 x4)))))))))
(define-fun
  (par (a b)
    (zipConcat :source Definitions.zipConcat
       ((x a) (y (list a)) (z (list b))) (list (pair a b))
       (match z
         (case nil (as nil (list (pair a b))))
         (case (cons y2 ys) (cons (pair2 x y2) (zip y ys)))))))
(prove
  :source Properties.prop_44
  (par (a b)
    (forall ((x a) (xs (list a)) (ys (list b)))
      (= (zip (cons x xs) ys) (zipConcat x xs ys)))))
