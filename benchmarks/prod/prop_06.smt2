; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x7 Nat) (x8 Nat)) Nat))
  ((match x7
     (case Z x8)
     (case (S x9) (S (plus x9 x8))))))
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
  (not
    (forall
      ((x10 (list a5)) (y (list a5)))
      (= (length (rev (append x10 y))) (plus (length x10) (length y))))))
(check-sat)
