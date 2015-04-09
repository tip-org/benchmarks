; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le
      ((x8 Nat) (x9 Nat)) bool
      (match x8
        (case Z true)
        (case
          (S ipv)
          (match x9
            (case Z false)
            (case (S ipv2) (le ipv ipv2))))))))
(define-funs-rec
  ((sorted
      ((x (list Nat))) bool
      (match x
        (case nil true)
        (case
          (cons x2 ds)
          (match ds
            (case nil true)
            (case (cons y xs) (ite (le x2 y) (sorted ds) (le x2 y)))))))))
(define-funs-rec
  ((insert2
      ((x5 Nat) (x6 (list Nat))) (list Nat)
      (match x6
        (case nil (cons x5 x6))
        (case
          (cons x7 xs3)
          (ite (le x5 x7) (cons x5 x6) (cons x7 (insert2 x5 xs3))))))))
(define-funs-rec
  ((isort
      ((x3 (list Nat))) (list Nat)
      (match x3
        (case nil x3)
        (case (cons x4 xs2) (insert2 x4 (isort xs2)))))))
(assert (not (forall ((x10 (list Nat))) (sorted (isort x10)))))
(check-sat)
