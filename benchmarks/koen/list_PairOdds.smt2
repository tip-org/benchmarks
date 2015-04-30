(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(define-funs-rec
  ((par (a b) (snd ((x (Pair2 a b))) b)))
  ((match x (case (Pair y z) z))))
(define-funs-rec
  ((par (t) (pairs ((x (list t))) (list (Pair2 t t)))))
  ((match x
     (case nil (as nil (list (Pair2 t t))))
     (case (cons y z)
       (match z
         (case nil (as nil (list (Pair2 t t))))
         (case (cons y2 xs) (cons (Pair y y2) (pairs xs))))))))
(define-funs-rec
  ((par (t t2) (map2 ((f (=> t2 t)) (x (list t2))) (list t))))
  ((match x
     (case nil (as nil (list t)))
     (case (cons y z) (cons (@ f y) (map2 f z))))))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil x)
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil x)
     (case (cons y xs) (evens xs)))))
(assert-not
  (par (t)
    (forall ((xs (list t)))
      (= (map2 (lambda ((x (Pair2 t t))) (snd x)) (pairs xs))
        (odds xs)))))
(check-sat)
