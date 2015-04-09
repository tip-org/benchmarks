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
  ((par (a2) (length ((x (list a2))) Nat)))
  ((match x
     (case nil Z)
     (case (cons ds xs) (S (as (length xs) Nat))))))
(define-funs-rec
  ((even ((x2 Nat)) bool))
  ((match x2
     (case Z true)
     (case
       (S ds2)
       (match ds2
         (case Z false)
         (case (S x3) (even x3)))))))
(define-funs-rec
  ((par (a3) (append ((x4 (list a3)) (x5 (list a3))) (list a3))))
  ((match x4
     (case nil x5)
     (case (cons x6 xs2) (cons x6 (as (append xs2 x5) (list a3)))))))
(declare-sort a4 0)
(assert
  (not
    (forall
      ((x10 (list a4)) (y (list a4)))
      (=
        (even (length (append x10 y)))
        (even (plus (length y) (length x10)))))))
(check-sat)
