; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((lt ((x9 Nat) (x10 Nat)) bool))
  ((match x10
     (case Z false)
     (case
       (S ipv2)
       (match x9
         (case Z true)
         (case (S x11) (lt x11 ipv2)))))))
(define-funs-rec
  ((ins ((x Nat) (x2 (list Nat))) (list Nat)))
  ((match x2
     (case nil (cons x x2))
     (case
       (cons x3 xs) (ite (lt x x3) (cons x x2) (cons x3 (ins x xs)))))))
(define-funs-rec
  ((equal ((x7 Nat) (x8 Nat)) bool))
  ((match x7
     (case
       Z
       (match x8
         (case Z true)
         (case (S ipv) false)))
     (case
       (S ds)
       (match x8
         (case Z false)
         (case (S y) (equal ds y)))))))
(define-funs-rec
  ((elem ((x4 Nat) (x5 (list Nat))) bool))
  ((match x5
     (case nil false)
     (case
       (cons x6 xs2) (ite (equal x4 x6) (equal x4 x6) (elem x4 xs2))))))
(assert-not
  (forall ((x12 Nat) (xs3 (list Nat))) (elem x12 (ins x12 xs3))))
(check-sat)
