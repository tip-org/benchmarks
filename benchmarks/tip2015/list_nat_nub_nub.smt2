(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (filter
       ((p (=> a Bool)) (x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs)
           (ite (@ p y) (cons y (filter p xs)) (filter p xs)))))))
(define-fun-rec
  (par (a)
    (nubBy
       ((x (=> a (=> a Bool))) (y (list a))) (list a)
       (match y
         (case nil (as nil (list a)))
         (case (cons z xs)
           (cons z
             (nubBy x (filter (lambda ((y2 a)) (not (@ (@ x z) y2))) xs))))))))
(assert-not
  (par (a)
    (forall ((xs (list a)))
      (=
        (nubBy (lambda ((x a)) (lambda ((y a)) (= x y)))
          (nubBy (lambda ((z a)) (lambda ((x2 a)) (= z x2))) xs))
        (nubBy (lambda ((x3 a)) (lambda ((x4 a)) (= x3 x4))) xs)))))
(check-sat)
