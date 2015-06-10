; Injectivity of append
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(assert-not
  (par (a)
    (forall ((xs (list a)) (ys (list a)) (zs (list a)))
      (=> (= (append xs ys) (append xs zs)) (= ys zs)))))
(check-sat)
