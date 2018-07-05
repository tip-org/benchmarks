(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree
     (Node (proj1-Node (Tree a)) (proj2-Node a) (proj3-Node (Tree a)))
     (Nil))))
(define-fun-rec
  (par (a)
    (flatten2
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (Node p z q) (flatten2 p (cons z (flatten2 q y))))
         (case Nil y)))))
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
  (par (a)
    (forall ((p (Tree a))) (= (flatten2 p (_ nil a)) (flatten0 p)))))
