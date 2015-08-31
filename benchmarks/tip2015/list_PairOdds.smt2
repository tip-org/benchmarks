(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-fun
  (par (a b)
    (snd ((x (Pair a b))) b (match x (case (Pair2 y z) z)))))
(define-fun-rec
  (par (t)
    (pairs
       ((x (list t))) (list (Pair t t))
       (match x
         (case nil (as nil (list (Pair t t))))
         (case (cons y z)
           (match z
             (case nil (as nil (list (Pair t t))))
             (case (cons y2 xs) (cons (Pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  (par (a b)
    (map2
       ((x (=> a b)) (y (list a))) (list b)
       (match y
         (case nil (as nil (list b)))
         (case (cons z xs) (cons (@ x z) (map2 x xs)))))))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (as nil (list a)))
     (case (cons y xs) (evens xs)))))
(assert-not
  (par (b)
    (forall ((xs (list b)))
      (= (map2 (lambda ((x (Pair b b))) (snd x)) (pairs xs))
        (odds xs)))))
(check-sat)
