; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
  ((elem ((x Nat) (x2 (list Nat))) bool))
  ((match x2
     (case nil false)
     (case (cons x3 xs) (ite (equal x x3) (equal x x3) (elem x xs))))))
(define-funs-rec
  ((delete ((x4 Nat) (x5 (list Nat))) (list Nat)))
  ((match x5
     (case nil x5)
     (case
       (cons x6 xs2)
       (ite (equal x4 x6) (delete x4 xs2) (cons x6 (delete x4 xs2)))))))
(assert-not
  (forall
    ((x9 Nat) (xs3 (list Nat))) (not (elem x9 (delete x9 xs3)))))
(check-sat)
