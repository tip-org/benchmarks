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
  ((le ((x Nat) (y Nat)) bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (le z x2)))))))
(define-funs-rec
  ((insert2 ((x Nat) (y (list Nat))) (list Nat)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs)
       (ite (le x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list Nat))) (list Nat)))
  ((match x
     (case nil x)
     (case (cons y xs) (insert2 y (isort xs))))))
(assert-not
  (forall ((x (list Nat))) (= (length (isort x)) (length x))))
(check-sat)
