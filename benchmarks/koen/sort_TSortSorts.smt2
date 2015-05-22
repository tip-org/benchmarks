; Tree sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (TNode (TNode_0 (Tree a)) (TNode_1 a) (TNode_2 (Tree a)))
     (TNil))))
(define-funs-rec
  ((par (a) (flatten ((x (Tree a)) (y (list a))) (list a))))
  ((match x
     (case (TNode p z q) (flatten p (cons z (flatten q y))))
     (case TNil y))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((ordered ((x (list Int))) Bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 xs) (and2 (<= y y2) (ordered z))))))))
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
(assert-not (forall ((x (list Int))) (ordered (tsort x))))
(check-sat)
