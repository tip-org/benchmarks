; Tree sort
;
; The sort function returns a sorted list.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree
     (Node (proj1-Node (Tree a)) (proj2-Node a) (proj3-Node (Tree a)))
     (Nil))))
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
         (case (Node p z q) (flatten p (cons z (flatten q y))))
         (case Nil y)))))
(define-fun-rec
  add
    ((x Int) (y (Tree Int))) (Tree Int)
    (match y
      (case (Node p z q)
        (ite (<= x z) (Node (add x p) z q) (Node p z (add x q))))
      (case Nil (Node (as Nil (Tree Int)) x (as Nil (Tree Int))))))
(define-fun-rec
  toTree
    ((x (list Int))) (Tree Int)
    (match x
      (case nil (as Nil (Tree Int)))
      (case (cons y xs) (add y (toTree xs)))))
(define-fun
  tsort
    ((x (list Int))) (list Int)
    (flatten (toTree x) (as nil (list Int))))
(assert-not (forall ((x (list Int))) (ordered-ordered1 (tsort x))))
(check-sat)
