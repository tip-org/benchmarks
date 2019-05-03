(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Tree
  (par (a)
    ((Node (proj1-Node (Tree a)) (proj2-Node a) (proj3-Node (Tree a)))
     (Nil))))
(define-fun-rec
  flatten3
  (par (a) (((x (Tree a))) (list a)))
  (match x
    (((Node y z r)
      (match y
        (((Node p x2 q) (flatten3 (Node p x2 (Node q z r))))
         (Nil (cons z (flatten3 r))))))
     (Nil (_ nil a)))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  flatten0
  (par (a) (((x (Tree a))) (list a)))
  (match x
    (((Node p y q)
      (++ (flatten0 p) (++ (cons y (_ nil a)) (flatten0 q))))
     (Nil (_ nil a)))))
(prove
  (par (a) (forall ((p (Tree a))) (= (flatten3 p) (flatten0 p)))))
