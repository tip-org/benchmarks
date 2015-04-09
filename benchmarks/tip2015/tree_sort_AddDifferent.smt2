; Tree sort
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes
  (a2)
  ((Tree
     (Node (Node_ (Tree a2)) (Node_2 a2) (Node_3 (Tree a2))) (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x11 Nat) (x12 Nat)) bool))
  ((match x11
     (case Z true)
     (case
       (S d2)
       (match x12
         (case Z false)
         (case (S d3) (le d2 d3)))))))
(define-funs-rec
  ((par (a3) (flatten ((x (Tree a3)) (x2 (list a3))) (list a3))))
  ((match x
     (case
       (Node p2 x3 q)
       (as (flatten p2 (cons x3 (as (flatten q x2) (list a3))))
         (list a3)))
     (case Nil x2))))
(define-funs-rec
  ((equal ((x8 Nat) (x9 Nat)) bool))
  ((match x8
     (case
       Z
       (match x9
         (case Z true)
         (case (S d) false)))
     (case
       (S x10)
       (match x9
         (case Z false)
         (case (S y3) (equal x10 y3)))))))
(define-funs-rec
  ((count ((x4 Nat) (x5 (list Nat))) Nat))
  ((match x5
     (case nil Z)
     (case
       (cons y xs) (ite (equal x4 y) (S (count x4 xs)) (count x4 xs))))))
(define-funs-rec
  ((add ((x6 Nat) (x7 (Tree Nat))) (Tree Nat)))
  ((match x7
     (case
       (Node p3 y2 q2)
       (ite (le x6 y2) (Node (add x6 p3) y2 q2) (Node p3 y2 (add x6 q2))))
     (case Nil (Node x7 x6 x7)))))
(assert
  (not
    (forall
      ((x13 Nat) (y4 Nat) (t (Tree Nat)))
      (=>
        (not (equal x13 y4))
        (=
          (count y4 (flatten (add x13 t) (as nil (list Nat))))
          (count y4 (flatten t (as nil (list Nat)))))))))
(check-sat)
