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
(define-fun-rec
  (par (a)
    (elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(assert-not
  (par (a)
    (forall ((x a) (xs (list a)))
      (=> (elem x xs)
        (elem x (nubBy (lambda ((y a)) (lambda ((z a)) (= y z))) xs))))))
(check-sat)
