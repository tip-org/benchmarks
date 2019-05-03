(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  filter
  (par (a) (((p (=> a Bool)) (x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (ite (@ p y) (cons y (filter p xs)) (filter p xs))))))
(define-fun-rec
  nubBy
  (par (a) (((x (=> a (=> a Bool))) (y (list a))) (list a)))
  (match y
    ((nil (_ nil a))
     ((cons z xs)
      (cons z
        (nubBy x (filter (lambda ((y2 a)) (not (@ (@ x z) y2))) xs)))))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(prove
  (par (a)
    (forall ((x a) (xs (list a)))
      (=> (elem x xs)
        (elem x (nubBy (lambda ((y a)) (lambda ((z a)) (= y z))) xs))))))
