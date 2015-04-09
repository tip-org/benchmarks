; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x6 Nat) (x7 Nat)) bool))
  ((match x6
     (case Z true)
     (case
       (S ipv)
       (match x7
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
  ((insort ((x3 Nat) (x4 (list Nat))) (list Nat)))
  ((match x4
     (case nil (cons x3 x4))
     (case
       (cons x5 xs)
       (ite (le x3 x5) (cons x3 x4) (cons x5 (insort x3 xs)))))))
(assert
  (not
    (forall
      ((x8 Nat) (xs2 (list Nat)))
      (=> (sorted xs2) (sorted (insort x8 xs2))))))
(check-sat)
