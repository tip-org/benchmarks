; Tree sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (TNode (TNode_0 (Tree a)) (TNode_1 a) (TNode_2 (Tree a)))
     (TNil))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
(define-fun-rec
  zdelete
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys) (ite (= x z) ys (cons z (zdelete x ys))))))
(define-fun
  (par (a)
    (null
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  zisPermutation
    ((x (list Int)) (y (list Int))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (and (zelem z y) (zisPermutation xs (zdelete z y))))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (TNode p z q) (flatten p (cons z (flatten q y))))
         (case TNil y)))))
(define-fun-rec
  add
    ((x Int) (y (Tree Int))) (Tree Int)
    (match y
      (case (TNode p z q)
        (ite (<= x z) (TNode (add x p) z q) (TNode p z (add x q))))
      (case TNil (TNode (as TNil (Tree Int)) x (as TNil (Tree Int))))))
(define-fun-rec
  toTree
    ((x (list Int))) (Tree Int)
    (match x
      (case nil (as TNil (Tree Int)))
      (case (cons y xs) (add y (toTree xs)))))
(define-fun
  tsort
    ((x (list Int))) (list Int)
    (flatten (toTree x) (as nil (list Int))))
(assert-not (forall ((x (list Int))) (zisPermutation (tsort x) x)))
(check-sat)
