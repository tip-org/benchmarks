; Source: Productive use of failure
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (length ((x (list a))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (as (length xs) Nat))))))
(define-funs-rec
  ((double ((x Nat)) Nat))
  ((match x
     (case Z x)
     (case (S y) (S (S (double y)))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(assert-not
  (par (a)
    (forall ((x (list a)))
      (= (length (append x x)) (double (length x))))))
(check-sat)
