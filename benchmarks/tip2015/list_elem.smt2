(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (elem :let :source Prelude.elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (!! :source Prelude.!!
       ((x (list a)) (y Int)) a
       (match (< y 0)
         (case false
           (match x (case (cons z x2) (ite (= y 0) z (!! x2 (- y 1))))))))))
(prove
  :source List.prop_elem
  (par (a)
    (forall ((x a) (xs (list a)))
      (=> (elem x xs) (exists ((y Int)) (= x (!! xs y)))))))
