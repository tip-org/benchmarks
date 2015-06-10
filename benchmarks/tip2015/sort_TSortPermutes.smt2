; Tree sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (TNode (TNode_0 (Tree a)) (TNode_1 a) (TNode_2 (Tree a)))
     (TNil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (flatten ((x (Tree a)) (y (list a))) (list a))))
  ((match x
     (case (TNode q z q2) (flatten q (cons z (flatten q2 y))))
     (case TNil y))))
(define-funs-rec
  ((count ((x Int) (y (list Int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
(define-funs-rec
  ((add ((x Int) (y (Tree Int))) (Tree Int)))
  ((match y
     (case (TNode q z q2)
       (ite (<= x z) (TNode (add x q) z q2) (TNode q z (add x q2))))
     (case TNil (TNode (as TNil (Tree Int)) x (as TNil (Tree Int)))))))
(define-funs-rec
  ((toTree ((x (list Int))) (Tree Int)))
  ((match x
     (case nil (as TNil (Tree Int)))
     (case (cons y xs) (add y (toTree xs))))))
(define-funs-rec
  ((tsort ((x (list Int))) (list Int)))
  ((flatten (toTree x) (as nil (list Int)))))
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (count x (tsort y)) (count x y))))
(check-sat)
