(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a b)
    (map2
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (as nil (list b)))
         (case (cons y xs) (cons (@ f y) (map2 f xs)))))))
(define-fun-rec
  (par (a)
    (elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(assert-not
  (par (a)
    (forall ((y a) (f (=> a a)) (xs (list a)))
      (=> (elem y (map2 f xs))
        (exists ((x a)) (and (= (@ f x) y) (elem y xs)))))))
(check-sat)
