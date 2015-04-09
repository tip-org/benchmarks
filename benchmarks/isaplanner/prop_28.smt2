; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((equal ((x4 Nat) (x5 Nat)) bool))
  ((match x4
     (case
       Z
       (match x5
         (case Z true)
         (case (S ipv) false)))
     (case
       (S ds)
       (match x5
         (case Z false)
         (case (S y) (equal ds y)))))))
(define-funs-rec
  ((elem ((x Nat) (x2 (list Nat))) bool))
  ((match x2
     (case nil false)
     (case (cons x3 xs) (ite (equal x x3) (equal x x3) (elem x xs))))))
(define-funs-rec
  ((par (a2) (append ((x6 (list a2)) (x7 (list a2))) (list a2))))
  ((match x6
     (case nil x7)
     (case (cons x8 xs2) (cons x8 (as (append xs2 x7) (list a2)))))))
(assert-not
  (forall
    ((x9 Nat) (xs3 (list Nat)))
    (elem x9 (append xs3 (cons x9 (as nil (list Nat)))))))
(check-sat)
