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
(prove
  (par (a)
    (forall ((xs (list a)))
      (=
        (nubBy (lambda ((x a)) (lambda ((y a)) (= x y)))
          (nubBy (lambda ((z a)) (lambda ((x2 a)) (= z x2))) xs))
        (nubBy (lambda ((x3 a)) (lambda ((x4 a)) (= x3 x4))) xs)))))
