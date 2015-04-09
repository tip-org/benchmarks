; Tree sort
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes
  (a2)
  ((Tree
     (Node (Node_ (Tree a2)) (Node_2 a2) (Node_3 (Tree a2))) (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec ((or2 ((x bool) (x2 bool)) bool (ite x x x2))))
(define-funs-rec
  ((par
     (a3)
     (null
        ((x5 (list a3))) bool
        (match x5
          (case nil true)
          (case (cons ds ds2) false))))))
(define-funs-rec
  ((le
      ((x24 Nat) (x25 Nat)) bool
      (match x24
        (case Z true)
        (case
          (S d2)
          (match x25
            (case Z false)
            (case (S d3) (le d2 d3))))))))
(define-funs-rec
  ((par
     (a4)
     (flatten
        ((x12 (Tree a4)) (x13 (list a4))) (list a4)
        (match x12
          (case
            (Node p2 x14 q)
            (as (flatten p2 (cons x14 (as (flatten q x13) (list a4))))
              (list a4)))
          (case Nil x13))))))
(define-funs-rec
  ((equal
      ((x21 Nat) (x22 Nat)) bool
      (match x21
        (case
          Z
          (match x22
            (case Z true)
            (case (S d) false)))
        (case
          (S x23)
          (match x22
            (case Z false)
            (case (S y4) (equal x23 y4))))))))
(define-funs-rec
  ((elem
      ((x15 Nat) (x16 (list Nat))) bool
      (match x16
        (case nil false)
        (case (cons y ys) (or2 (equal x15 y) (elem x15 ys)))))))
(define-funs-rec
  ((delete
      ((x17 Nat) (x18 (list Nat))) (list Nat)
      (match x18
        (case nil x18)
        (case
          (cons y2 ys2)
          (ite (equal x17 y2) ys2 (cons y2 (delete x17 ys2))))))))
(define-funs-rec
  ((and2 ((x3 bool) (x4 bool)) bool (ite x3 x4 x3))))
(define-funs-rec
  ((isPermutation
      ((x9 (list Nat)) (x10 (list Nat))) bool
      (match x9
        (case nil (null x10))
        (case
          (cons x11 xs2)
          (and2 (elem x11 x10) (isPermutation xs2 (delete x11 x10))))))))
(define-funs-rec
  ((add
      ((x19 Nat) (x20 (Tree Nat))) (Tree Nat)
      (match x20
        (case
          (Node p3 y3 q2)
          (ite
            (le x19 y3) (Node (add x19 p3) y3 q2) (Node p3 y3 (add x19 q2))))
        (case Nil (Node x20 x19 x20))))))
(define-funs-rec
  ((toTree
      ((x7 (list Nat))) (Tree Nat)
      (match x7
        (case nil (as Nil (Tree Nat)))
        (case (cons x8 xs) (add x8 (toTree xs)))))))
(define-funs-rec
  ((tsort
      ((x6 (list Nat))) (list Nat)
      (flatten (toTree x6) (as nil (list Nat))))))
(assert
  (not (forall ((ds3 (list Nat))) (isPermutation (tsort ds3) ds3))))
(check-sat)
