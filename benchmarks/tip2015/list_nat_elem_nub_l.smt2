(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (filter :let :source Prelude.filter
       ((p (=> a Bool)) (x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs)
           (ite (@ p y) (cons y (filter p xs)) (filter p xs)))))))
(define-fun-rec
  (par (a)
    (nubBy :source Data.List.nubBy
       ((x (=> a (=> a Bool))) (y (list a))) (list a)
       (match y
         (case nil (as nil (list a)))
         (case (cons z xs)
           (cons z
             (nubBy x (filter (lambda ((y2 a)) (not (@ (@ x z) y2))) xs))))))))
(define-fun-rec
  (par (a)
    (elem :let :source Prelude.elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(prove
  :source List.prop_elem_nub_l
  (par (a)
    (forall ((x a) (xs (list a)))
      (=> (elem x xs)
        (elem x (nubBy (lambda ((y a)) (lambda ((z a)) (= y z))) xs))))))
