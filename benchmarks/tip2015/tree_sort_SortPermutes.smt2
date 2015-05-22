; Tree sort
;
; The sort function permutes the input list.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (Node (Node_0 (Tree a)) (Node_1 a) (Node_2 (Tree a)))
     (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
  ((count ((x Nat) (y (list Nat))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs)
       (ite (equal x z) (S (count x xs)) (count x xs))))))
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
(assert-not
  (forall ((x Nat) (y (list Nat)))
    (= (count x (tsort y)) (count x y))))
(check-sat)
