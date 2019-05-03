(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Tree
  (par (a)
    ((Node (proj1-Node (Tree a)) (proj2-Node a) (proj3-Node (Tree a)))
     (Nil))))
(define-fun-rec
  swap
  ((x Int) (y Int) (z (Tree Int))) (Tree Int)
  (match z
    (((Node p x2 q)
      (ite
        (= x2 x) (Node (swap x y p) y (swap x y q))
        (ite
          (= x2 y) (Node (swap x y p) x (swap x y q))
          (Node (swap x y p) x2 (swap x y q)))))
     (Nil (_ Nil Int)))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
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
  (forall ((p (Tree Int)) (a Int) (b Int))
    (=> (elem a (flatten0 p))
      (=> (elem b (flatten0 p))
        (and (elem a (flatten0 (swap a b p)))
          (elem b (flatten0 (swap a b p))))))))
