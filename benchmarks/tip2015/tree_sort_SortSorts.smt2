; Tree sort
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes
  (a2)
  ((Tree
     (Node (Node_ (Tree a2)) (Node_2 a2) (Node_3 (Tree a2))) (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le
      ((x13 Nat) (x14 Nat)) bool
      (match x13
        (case Z true)
        (case
          (S d)
          (match x14
            (case Z false)
            (case (S d2) (le d d2))))))))
(define-funs-rec
  ((par
     (a3)
     (flatten
        ((x8 (Tree a3)) (x9 (list a3))) (list a3)
        (match x8
          (case
            (Node p2 x10 q)
            (as (flatten p2 (cons x10 (as (flatten q x9) (list a3))))
              (list a3)))
          (case Nil x9))))))
(define-funs-rec ((and2 ((x bool) (x2 bool)) bool (ite x x2 x))))
(define-funs-rec
  ((ordered
      ((x6 (list Nat))) bool
      (match x6
        (case nil true)
        (case
          (cons x7 ds)
          (match ds
            (case nil true)
            (case (cons y xs2) (and2 (le x7 y) (ordered ds)))))))))
(define-funs-rec
  ((add
      ((x11 Nat) (x12 (Tree Nat))) (Tree Nat)
      (match x12
        (case
          (Node p3 y2 q2)
          (ite
            (le x11 y2) (Node (add x11 p3) y2 q2) (Node p3 y2 (add x11 q2))))
        (case Nil (Node x12 x11 x12))))))
(define-funs-rec
  ((toTree
      ((x4 (list Nat))) (Tree Nat)
      (match x4
        (case nil (as Nil (Tree Nat)))
        (case (cons x5 xs) (add x5 (toTree xs)))))))
(define-funs-rec
  ((tsort
      ((x3 (list Nat))) (list Nat)
      (flatten (toTree x3) (as nil (list Nat))))))
(assert (not (forall ((ds2 (list Nat))) (ordered (tsort ds2)))))
(check-sat)
