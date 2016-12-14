; Injectivity of append
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(assert-not
  (par (a)
    (forall ((xs (list a)) (ys (list a)) (zs (list a)))
      (=> (= (++ xs ys) (++ xs zs)) (= ys zs)))))
(check-sat)
