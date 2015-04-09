; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par
     (a2)
     (length
        ((x (list a2))) Nat
        (match x
          (case nil Z)
          (case (cons ds xs) (S (as (length xs) Nat))))))))
(define-funs-rec
  ((le
      ((x7 Nat) (x8 Nat)) bool
      (match x7
        (case Z true)
        (case
          (S ipv)
          (match x8
            (case Z false)
            (case (S ipv2) (le ipv ipv2))))))))
(define-funs-rec
  ((insert2
      ((x4 Nat) (x5 (list Nat))) (list Nat)
      (match x5
        (case nil (cons x4 x5))
        (case
          (cons x6 xs3)
          (ite (le x4 x6) (cons x4 x5) (cons x6 (insert2 x4 xs3))))))))
(define-funs-rec
  ((isort
      ((x2 (list Nat))) (list Nat)
      (match x2
        (case nil x2)
        (case (cons x3 xs2) (insert2 x3 (isort xs2)))))))
(assert
  (not
    (forall ((x9 (list Nat))) (= (length (isort x9)) (length x9)))))
(check-sat)
