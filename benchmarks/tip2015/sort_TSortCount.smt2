; Tree sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (TNode (TNode_0 (Tree a)) (TNode_1 a) (TNode_2 (Tree a)))
     (TNil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zcount
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (zcount x xs)) (zcount x xs)))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (TNode q z q2) (flatten q (cons z (flatten q2 y))))
         (case TNil y)))))
(define-fun-rec
  add
    ((x Int) (y (Tree Int))) (Tree Int)
    (match y
      (case (TNode q z q2)
        (ite (<= x z) (TNode (add x q) z q2) (TNode q z (add x q2))))
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
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (zcount x (tsort y)) (zcount x y))))
(check-sat)
