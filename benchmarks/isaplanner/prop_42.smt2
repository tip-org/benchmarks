; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (take ((x Nat) (y (list a))) (list a))))
  ((match x
     (case Z (as nil (list a)))
     (case (S z)
       (match y
         (case nil y)
         (case (cons x2 x3) (cons x2 (as (take z x3) (list a)))))))))
(assert-not
  (par (a)
    (forall ((n Nat) (x a) (xs (list a)))
      (= (take (S n) (cons x xs)) (cons x (take n xs))))))
(check-sat)
