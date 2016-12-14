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
    (flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (TNode p z q) (flatten p (cons z (flatten q y))))
         (case TNil y)))))
(define-fun-rec
  (par (a)
    (elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (as nil (list a)))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  (par (a)
    (isPermutation
       ((x (list a)) (y (list a))) Bool
       (match x
         (case nil
           (match y
             (case nil true)
             (case (cons z x2) false)))
         (case (cons x3 xs)
           (and (elem x3 y)
             (isPermutation xs
               (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5)))
                 x3 y))))))))
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
(assert-not (forall ((x (list Int))) (isPermutation (tsort x) x)))
(check-sat)
