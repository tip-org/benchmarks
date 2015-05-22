; Tree sort
;
; The sort function permutes the input list, version 2.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (Node (Node_0 (Tree a)) (Node_1 a) (Node_2 (Tree a)))
     (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec ((or2 ((x Bool) (y Bool)) Bool)) ((ite x true y)))
(define-funs-rec
  ((par (a) (null ((x (list a))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((le ((x Nat) (y Nat)) Bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (le z x2)))))))
(define-funs-rec
  ((par (a) (flatten ((x (Tree a)) (y (list a))) (list a))))
  ((match x
     (case (Node q z q2) (flatten q (cons z (flatten q2 y))))
     (case Nil y))))
(define-funs-rec
  ((equal ((x Nat) (y Nat)) Bool))
  ((match x
     (case Z
       (match y
         (case Z true)
         (case (S z) false)))
     (case (S x2)
       (match y
         (case Z false)
         (case (S y2) (equal x2 y2)))))))
(define-funs-rec
  ((elem ((x Nat) (y (list Nat))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (equal x z) (elem x ys))))))
(define-funs-rec
  ((delete ((x Nat) (y (list Nat))) (list Nat)))
  ((match y
     (case nil (as nil (list Nat)))
     (case (cons z ys) (ite (equal x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list Nat)) (y (list Nat))) Bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(define-funs-rec
  ((add ((x Nat) (y (Tree Nat))) (Tree Nat)))
  ((match y
     (case (Node q z q2)
       (ite (le x z) (Node (add x q) z q2) (Node q z (add x q2))))
     (case Nil (Node (as Nil (Tree Nat)) x (as Nil (Tree Nat)))))))
(define-funs-rec
  ((toTree ((x (list Nat))) (Tree Nat)))
  ((match x
     (case nil (as Nil (Tree Nat)))
     (case (cons y xs) (add y (toTree xs))))))
(define-funs-rec
  ((tsort ((x (list Nat))) (list Nat)))
  ((flatten (toTree x) (as nil (list Nat)))))
(assert-not (forall ((x (list Nat))) (isPermutation (tsort x) x)))
(check-sat)
