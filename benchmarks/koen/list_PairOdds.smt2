(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(define-funs-rec
  ((par (t t2) (x ((f (=> t2 t)) (y (list t2))) (list t))))
  ((match y
     (case nil (as nil (list t)))
     (case (cons z x2) (cons (@ f z) (x f x2))))))
(define-funs-rec
  ((par (a b) (snd ((y (Pair2 a b))) b)))
  ((match y (case (Pair z y2) y2))))
(define-funs-rec
  ((par (t) (pairs ((y (list t))) (list (Pair2 t t)))))
  ((match y
     (case nil (as nil (list (Pair2 t t))))
     (case (cons z x2)
       (match x2
         (case nil (as nil (list (Pair2 t t))))
         (case (cons y2 xs) (cons (Pair z y2) (pairs xs))))))))
(define-funs-rec
  ((par (a) (evens ((y (list a))) (list a)))
   (par (a) (odds ((y (list a))) (list a))))
  ((match y
     (case nil y)
     (case (cons z xs) (cons z (odds xs))))
   (match y
     (case nil y)
     (case (cons z xs) (evens xs)))))
(assert-not
  (par (t)
    (forall ((xs (list t)))
      (= (x (lambda ((y (Pair2 t t))) (snd y)) (pairs xs)) (odds xs)))))
(check-sat)
