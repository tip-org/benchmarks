; Tree sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (TNode (TNode_0 (Tree a)) (TNode_1 a) (TNode_2 (Tree a)))
     (TNil))))
(define-funs-rec
  ((insert2 ((x int) (y (list int))) (list int)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs)
       (ite (<= x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons y xs) (insert2 y (isort xs))))))
(define-funs-rec
  ((par (a) (flatten ((x (Tree a)) (y (list a))) (list a))))
  ((match x
     (case (TNode p z q) (flatten p (cons z (flatten q y))))
     (case TNil y))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((add ((x int) (y (Tree int))) (Tree int)))
  ((match y
     (case (TNode p z q)
       (ite (<= x z) (TNode (add x p) z q) (TNode p z (add x q))))
     (case TNil (TNode y x y)))))
(define-funs-rec
  ((toTree ((x (list int))) (Tree int)))
  ((match x
     (case nil (as TNil (Tree int)))
     (case (cons y xs) (add y (toTree xs))))))
(define-funs-rec
  ((tsort ((x (list int))) (list int)))
  ((dot
   (lambda ((y (=> (list int) (list int)))) (@ y (as nil (list int))))
     (lambda ((z (list int)))
       (dot
       (lambda ((x2 (Tree int)))
         (lambda ((x3 (list int))) (flatten x2 x3)))
         (lambda ((x4 (list int))) (toTree x4)) z))
     x)))
(assert-not (forall ((x (list int))) (= (tsort x) (isort x))))
(check-sat)
