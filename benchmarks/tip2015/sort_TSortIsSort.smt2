; Tree sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree
     (TNode (proj1-TNode (Tree a))
       (proj2-TNode a) (proj3-TNode (Tree a)))
     (TNil))))
(define-fun-rec
  (par (a)
    (insert2
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (cons x (as nil (list a))))
         (case (cons z xs)
           (ite (<= x z) (cons x y) (cons z (insert2 x xs))))))))
(define-fun-rec
  (par (a)
    (isort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (insert2 y (isort xs)))))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (TNode p z q) (flatten p (cons z (flatten q y))))
         (case TNil y)))))
(define-fun-rec
  (par (a)
    (add
       ((x a) (y (Tree a))) (Tree a)
       (match y
         (case (TNode p z q)
           (ite (<= x z) (TNode (add x p) z q) (TNode p z (add x q))))
         (case TNil (TNode (as TNil (Tree a)) x (as TNil (Tree a))))))))
(define-fun-rec
  (par (a)
    (toTree
       ((x (list a))) (Tree a)
       (match x
         (case nil (as TNil (Tree a)))
         (case (cons y xs) (add y (toTree xs)))))))
(define-fun
  (par (a)
    (tsort
       ((x (list a))) (list a) (flatten (toTree x) (as nil (list a))))))
(assert-not (forall ((x (list Int))) (= (tsort x) (isort x))))
(check-sat)
