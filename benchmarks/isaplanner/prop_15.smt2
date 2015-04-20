; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((lt ((x Nat) (y Nat)) bool))
  ((match y
     (case Z false)
     (case (S z)
       (match x
         (case Z true)
         (case (S x2) (lt x2 z)))))))
(define-funs-rec
  ((par (a) (len ((x (list a))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((ins ((x Nat) (y (list Nat))) (list Nat)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs) (ite (lt x z) (cons x y) (cons z (ins x xs)))))))
(assert-not
  (forall ((x Nat) (xs (list Nat)))
    (= (len (ins x xs)) (S (len xs)))))
(check-sat)
