; Tree sort
;
; The sort function returns a sorted list.
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
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((ordered ((x (list Nat))) Bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 xs) (and2 (le y y2) (ordered z))))))))
(define-funs-rec
  ((add ((x Nat) (y (Tree Nat))) (Tree Nat)))
  ((match y
     (case (Node q z q2)
       (ite (le x z) (Node (add x q) z q2) (Node q z (add x q2))))
     (case Nil (Node y x y)))))
(define-funs-rec
  ((toTree ((x (list Nat))) (Tree Nat)))
  ((match x
     (case nil (as Nil (Tree Nat)))
     (case (cons y xs) (add y (toTree xs))))))
(define-funs-rec
  ((tsort ((x (list Nat))) (list Nat)))
  ((flatten (toTree x) (as nil (list Nat)))))
(assert-not (forall ((x (list Nat))) (ordered (tsort x))))
(check-sat)
