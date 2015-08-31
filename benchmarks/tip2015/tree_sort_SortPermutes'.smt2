; Tree sort
;
; The sort function permutes the input list, version 2.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (Node (Node_0 (Tree a)) (Node_1 a) (Node_2 (Tree a)))
     (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun
  (par (a)
    (null
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (Node q z q2) (flatten q (cons z (flatten q2 y))))
         (case Nil y)))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun-rec
  elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (equal x z) (elem x ys)))))
(define-fun-rec
  delete
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (as nil (list Nat)))
      (case (cons z xs) (ite (equal x z) xs (cons z (delete x xs))))))
(define-fun-rec
  isPermutation
    ((x (list Nat)) (y (list Nat))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (and (elem z y) (isPermutation xs (delete z y))))))
(define-fun-rec
  add
    ((x Nat) (y (Tree Nat))) (Tree Nat)
    (match y
      (case (Node q z q2)
        (ite (le x z) (Node (add x q) z q2) (Node q z (add x q2))))
      (case Nil (Node (as Nil (Tree Nat)) x (as Nil (Tree Nat))))))
(define-fun-rec
  toTree
    ((x (list Nat))) (Tree Nat)
    (match x
      (case nil (as Nil (Tree Nat)))
      (case (cons y xs) (add y (toTree xs)))))
(define-fun
  tsort
    ((x (list Nat))) (list Nat)
    (flatten (toTree x) (as nil (list Nat))))
(assert-not (forall ((x (list Nat))) (isPermutation (tsort x) x)))
(check-sat)
