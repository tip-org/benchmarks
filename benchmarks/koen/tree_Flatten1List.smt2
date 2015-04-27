(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (Node (Node_0 (Tree a)) (Node_1 a) (Node_2 (Tree a)))
     (Nil))))
(define-funs-rec
  ((par (a) (flatten1 ((x (list (Tree a)))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y ps)
       (match y
         (case (Node z x2 q)
           (match z
             (case (Node x3 x4 x5)
               (flatten1 (cons z (cons (Node (as Nil (Tree a)) x2 q) ps))))
             (case Nil (cons x2 (flatten1 (cons q ps))))))
         (case Nil (flatten1 ps)))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((par (t t2)
     (concatMap ((x (=> t (list t2))) (y (list t))) (list t2))))
  ((match y
     (case nil (as nil (list t2)))
     (case (cons z xs) (append (@ x z) (concatMap x xs))))))
(define-funs-rec
  ((par (a) (flatten0 ((x (Tree a))) (list a))))
  ((match x
     (case (Node p y q)
       (append (append (flatten0 p) (cons y (as nil (list a))))
         (flatten0 q)))
     (case Nil (as nil (list a))))))
(assert-not
  (par (a)
    (forall ((ps (list (Tree a))))
      (= (flatten1 ps)
        (concatMap (lambda ((x (Tree a))) (flatten0 x)) ps)))))
(check-sat)
