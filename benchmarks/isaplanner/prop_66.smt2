; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (len ((x (list a))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((le ((x Nat) (y Nat)) bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (le z x2)))))))
(define-funs-rec
  ((par (a) (filter ((x (=> a bool)) (y (list a))) (list a))))
  ((match y
     (case nil y)
     (case (cons z xs)
       (ite
         (@ x z) (cons z (as (filter x xs) (list a)))
         (as (filter x xs) (list a)))))))
(assert-not
  (par (a)
    (forall ((q (=> a bool)) (xs (list a)))
      (le (len (filter q xs)) (len xs)))))
(check-sat)
