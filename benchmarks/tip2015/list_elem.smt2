(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  !!
  (par (a) (((x (list a)) (y Int)) a))
  (match (< y 0)
    ((false
      (match x (((cons z x2) (ite (= y 0) z (!! x2 (- y 1))))))))))
(prove
  (par (a)
    (forall ((x a) (xs (list a)))
      (=> (elem x xs) (exists ((y Int)) (= x (!! xs y)))))))
