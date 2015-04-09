; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x8 Nat) (x9 Nat)) bool))
  ((match x8
     (case Z true)
     (case
       (S ipv)
       (match x9
         (case Z false)
         (case (S ipv2) (le ipv ipv2)))))))
(define-funs-rec
  ((sorted ((x (list Nat))) bool))
  ((match x
     (case nil true)
     (case
       (cons x2 ds)
       (match ds
         (case nil true)
         (case (cons y ys) (ite (le x2 y) (sorted ds) (le x2 y))))))))
(define-funs-rec
  ((insort ((x5 Nat) (x6 (list Nat))) (list Nat)))
  ((match x6
     (case nil (cons x5 x6))
     (case
       (cons x7 xs2)
       (ite (le x5 x7) (cons x5 x6) (cons x7 (insort x5 xs2)))))))
(define-funs-rec
  ((sort ((x3 (list Nat))) (list Nat)))
  ((match x3
     (case nil x3)
     (case (cons x4 xs) (insort x4 (sort xs))))))
(assert (not (forall ((xs3 (list Nat))) (sorted (sort xs3)))))
(check-sat)
