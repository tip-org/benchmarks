(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (Node (Node_0 (Tree a)) (Node_1 a) (Node_2 (Tree a)))
     (Nil))))
(define-funs-rec
  ((par (a) (flatten2 ((x (Tree a)) (y (list a))) (list a))))
  ((match x
     (case (Node p z q) (flatten2 p (cons z (flatten2 q y))))
     (case Nil y))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((par (a) (flatten0 ((x (Tree a))) (list a))))
  ((match x
     (case (Node p y q)
       (append (append (flatten0 p) (cons y (as nil (list a))))
         (flatten0 q)))
     (case Nil (as nil (list a))))))
(assert-not
  (par (a)
    (forall ((p (Tree a)))
      (= (flatten2 p (as nil (list a))) (flatten0 p)))))
(check-sat)
