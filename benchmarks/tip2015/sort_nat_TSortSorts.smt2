; Tree sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree
     (TNode (proj1-TNode (Tree a))
       (proj2-TNode a) (proj3-TNode (Tree a)))
     (TNil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (ordered-ordered1
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z)
           (match z
             (case nil true)
             (case (cons y2 xs) (and (<= y y2) (ordered-ordered1 z)))))))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (TNode q z r) (flatten q (cons z (flatten r y))))
         (case TNil y)))))
(define-fun-rec
  (par (a)
    (add
       ((x a) (y (Tree a))) (Tree a)
       (match y
         (case (TNode q z r)
           (ite (<= x z) (TNode (add x q) z r) (TNode q z (add x r))))
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
(assert-not (forall ((x (list Nat))) (ordered-ordered1 (tsort x))))
(check-sat)
