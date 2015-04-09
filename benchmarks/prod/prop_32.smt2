; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a4) (length ((x3 (list a4))) Nat)))
  ((match x3
     (case nil Z)
     (case (cons ds xs) (S (as (length xs) Nat))))))
(define-funs-rec
  ((par (a3) (append ((x4 (list a3)) (x5 (list a3))) (list a3))))
  ((match x4
     (case nil x5)
     (case (cons x6 xs2) (cons x6 (as (append xs2 x5) (list a3)))))))
(define-funs-rec
  ((par (a2) (rotate ((x Nat) (x2 (list a2))) (list a2))))
  ((match x
     (case Z x2)
     (case
       (S ipv)
       (match x2
         (case nil x2)
         (case
           (cons ipv2 ipv3)
           (as (rotate ipv (append ipv3 (cons ipv2 (as nil (list a2)))))
             (list a2))))))))
(declare-sort a5 0)
(assert
  (not (forall ((x7 (list a5))) (= (rotate (length x7) x7) x7))))
(check-sat)
