; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-sort Any 0)
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
         (case nil (_ nil (pair a b)))
         (case (cons z x2)
           (match y
             (case nil (_ nil (pair a b)))
             (case (cons x3 x4) (cons (pair2 z x3) (zip x2 x4)))))))))
(prove
  :source Properties.prop_46
  (par (b)
    (forall ((xs (list b)))
      (= (zip (_ nil Any) xs) (_ nil (pair Any b))))))
