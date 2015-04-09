; Tree sort
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes
  (a2)
  ((Tree
     (Node (Node_ (Tree a2)) (Node_2 a2) (Node_3 (Tree a2))) (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x14 Nat) (x15 Nat)) bool))
  ((match x14
     (case Z true)
     (case
       (S d2)
       (match x15
         (case Z false)
         (case (S d3) (le d2 d3)))))))
(define-funs-rec
  ((par (a3) (flatten ((x4 (Tree a3)) (x5 (list a3))) (list a3))))
  ((match x4
     (case
       (Node p2 x6 q)
       (as (flatten p2 (cons x6 (as (flatten q x5) (list a3))))
         (list a3)))
     (case Nil x5))))
(define-funs-rec
  ((equal ((x11 Nat) (x12 Nat)) bool))
  ((match x11
     (case
       Z
       (match x12
         (case Z true)
         (case (S d) false)))
     (case
       (S x13)
       (match x12
         (case Z false)
         (case (S y3) (equal x13 y3)))))))
(define-funs-rec
  ((count ((x7 Nat) (x8 (list Nat))) Nat))
  ((match x8
     (case nil Z)
     (case
       (cons y xs2)
       (ite (equal x7 y) (S (count x7 xs2)) (count x7 xs2))))))
(define-funs-rec
  ((add ((x9 Nat) (x10 (Tree Nat))) (Tree Nat)))
  ((match x10
     (case
       (Node p3 y2 q2)
       (ite (le x9 y2) (Node (add x9 p3) y2 q2) (Node p3 y2 (add x9 q2))))
     (case Nil (Node x10 x9 x10)))))
(define-funs-rec
  ((toTree ((x2 (list Nat))) (Tree Nat)))
  ((match x2
     (case nil (as Nil (Tree Nat)))
     (case (cons x3 xs) (add x3 (toTree xs))))))
(define-funs-rec
  ((tsort ((x (list Nat))) (list Nat)))
  ((flatten (toTree x) (as nil (list Nat)))))
(assert
  (not
    (forall
      ((x16 Nat) (ds (list Nat)))
      (= (count x16 (tsort ds)) (count x16 ds)))))
(check-sat)
