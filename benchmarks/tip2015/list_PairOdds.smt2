(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (t)
    (pairs
       ((x (list t))) (list (pair t t))
       (match x
         (case nil (as nil (list (pair t t))))
         (case (cons y z)
           (match z
             (case nil (as nil (list (pair t t))))
             (case (cons y2 xs) (cons (pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  (par (a b)
    (map2
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (as nil (list b)))
         (case (cons y xs) (cons (@ f y) (map2 f xs)))))))
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
  (par (a)
    (forall ((xs (list a)))
      (=
        (map2 (lambda ((x (pair a a))) (match x (case (pair2 y z) z)))
          (pairs xs))
        (odds xs)))))
(check-sat)
