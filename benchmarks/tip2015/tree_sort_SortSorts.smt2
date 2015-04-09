; Tree sort
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes
  (a2)
  ((Tree
     (Node (Node_ (Tree a2)) (Node_2 a2) (Node_3 (Tree a2))) (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x3 Nat) (x4 Nat)) bool))
  ((match x3
     (case Z true)
     (case
       (S d)
       (match x4
         (case Z false)
         (case (S d2) (le d d2)))))))
(define-funs-rec
  ((par (a3) (flatten ((x10 (Tree a3)) (x11 (list a3))) (list a3))))
  ((match x10
     (case
       (Node p3 x12 q2)
       (as (flatten p3 (cons x12 (as (flatten q2 x11) (list a3))))
         (list a3)))
     (case Nil x11))))
(define-funs-rec ((and2 ((x bool) (x2 bool)) bool)) ((ite x x2 x)))
(define-funs-rec
  ((ordered ((x13 (list Nat))) bool))
  ((match x13
     (case nil true)
     (case
       (cons x14 ds)
       (match ds
         (case nil true)
         (case (cons y2 xs2) (and2 (le x14 y2) (ordered ds))))))))
(define-funs-rec
  ((add ((x8 Nat) (x9 (Tree Nat))) (Tree Nat)))
  ((match x9
     (case
       (Node p2 y q)
       (ite (le x8 y) (Node (add x8 p2) y q) (Node p2 y (add x8 q))))
     (case Nil (Node x9 x8 x9)))))
(define-funs-rec
  ((toTree ((x6 (list Nat))) (Tree Nat)))
  ((match x6
     (case nil (as Nil (Tree Nat)))
     (case (cons x7 xs) (add x7 (toTree xs))))))
(define-funs-rec
  ((tsort ((x5 (list Nat))) (list Nat)))
  ((flatten (toTree x5) (as nil (list Nat)))))
(assert-not (forall ((ds2 (list Nat))) (ordered (tsort ds2))))
(check-sat)
