(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Tree
  (par (a)
    ((Node (proj1-Node (Tree a)) (proj2-Node a) (proj3-Node (Tree a)))
     (Nil))))
(define-fun-rec
  flatten2
  (par (a) (((x (Tree a)) (y (list a))) (list a)))
  (match x
    (((Node p z q) (flatten2 p (cons z (flatten2 q y))))
     (Nil y))))
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
  (par (a)
    (forall ((p (Tree a))) (= (flatten2 p (_ nil a)) (flatten0 p)))))
