(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree
     (Node (proj1-Node (Tree a)) (proj2-Node a) (proj3-Node (Tree a)))
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
         (case Nil (_ nil a))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (flatten0
       ((x (Tree a))) (list a)
       (match x
         (case (Node p y q)
           (++ (flatten0 p) (++ (cons y (_ nil a)) (flatten0 q))))
         (case Nil (_ nil a))))))
(prove
  (par (a) (forall ((p (Tree a))) (= (flatten3 p) (flatten0 p)))))
