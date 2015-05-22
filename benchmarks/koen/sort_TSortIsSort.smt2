; Tree sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (TNode (TNode_0 (Tree a)) (TNode_1 a) (TNode_2 (Tree a)))
     (TNil))))
(define-funs-rec
  ((insert2 ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs)
       (ite (<= x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list Int))) (list Int)))
  ((match x
     (case nil x)
     (case (cons y xs) (insert2 y (isort xs))))))
(define-funs-rec
  ((par (a) (flatten ((x (Tree a)) (y (list a))) (list a))))
  ((match x
     (case (TNode p z q) (flatten p (cons z (flatten q y))))
     (case TNil y))))
(define-funs-rec
  ((add ((x Int) (y (Tree Int))) (Tree Int)))
  ((match y
     (case (TNode p z q)
       (ite (<= x z) (TNode (add x p) z q) (TNode p z (add x q))))
     (case TNil (TNode y x y)))))
(define-funs-rec
  ((toTree ((x (list Int))) (Tree Int)))
  ((match x
     (case nil (as TNil (Tree Int)))
     (case (cons y xs) (add y (toTree xs))))))
(define-funs-rec
  ((tsort ((x (list Int))) (list Int)))
  ((flatten (toTree x) (as nil (list Int)))))
(assert-not (forall ((x (list Int))) (= (tsort x) (isort x))))
(check-sat)
