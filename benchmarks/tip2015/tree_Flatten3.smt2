(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (Node (Node_0 (Tree a)) (Node_1 a) (Node_2 (Tree a)))
     (Nil))))
(define-fun-rec
  (par (a)
    (flatten3
       ((x (Tree a))) (list a)
       (match x
         (case (Node y z r)
           (match y
             (case (Node p x2 q) (flatten3 (Node p x2 (Node q z r))))
             (case Nil (cons z (flatten3 r)))))
         (case Nil (as nil (list a)))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a)
    (flatten0
       ((x (Tree a))) (list a)
       (match x
         (case (Node p y q)
           (append (flatten0 p)
             (append (cons y (as nil (list a))) (flatten0 q))))
         (case Nil (as nil (list a)))))))
(assert-not
  (par (a) (forall ((p (Tree a))) (= (flatten3 p) (flatten0 p)))))
(check-sat)
