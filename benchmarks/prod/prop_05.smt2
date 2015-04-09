; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a4) (length ((x3 (list a4))) Nat)))
  ((match x3
     (case nil Z)
     (case (cons ds xs2) (S (as (length xs2) Nat))))))
(define-funs-rec
  ((par (a3) (append ((x4 (list a3)) (x5 (list a3))) (list a3))))
  ((match x4
     (case nil x5)
     (case (cons x6 xs3) (cons x6 (as (append xs3 x5) (list a3)))))))
(define-funs-rec
  ((par (a2) (rev ((x (list a2))) (list a2))))
  ((match x
     (case nil x)
     (case
       (cons x2 xs)
       (append (as (rev xs) (list a2)) (cons x2 (as nil (list a2))))))))
(declare-sort a5 0)
(assert
  (not (forall ((x7 (list a5))) (= (length (rev x7)) (length x7)))))
(check-sat)
