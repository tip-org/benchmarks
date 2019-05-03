(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Tree
  (par (a)
    ((Node (proj1-Node (Tree a)) (proj2-Node a) (proj3-Node (Tree a)))
     (Nil))))
(define-fun-rec
  flatten1
  (par (a) (((x (list (Tree a)))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y ps)
      (match y
        (((Node z x2 q)
          (match z
            (((Node x3 x4 x5)
              (flatten1 (cons z (cons (Node (_ Nil a) x2 q) ps))))
             (Nil (cons x2 (flatten1 (cons q ps)))))))
         (Nil (flatten1 ps))))))))
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
    (forall ((p (Tree a)))
      (= (flatten1 (cons p (_ nil (Tree a)))) (flatten0 p)))))
