; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((equal ((x Nat) (y Nat)) bool))
  ((match x
     (case Z
       (match y
         (case Z true)
         (case (S z) false)))
     (case (S x2)
       (match y
         (case Z false)
         (case (S y2) (equal x2 y2)))))))
(define-funs-rec
  ((elem ((x Nat) (y (list Nat))) bool))
  ((match y
     (case nil false)
     (case (cons z xs) (ite (equal x z) true (elem x xs))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(assert-not
  (forall ((x Nat) (xs (list Nat)) (ys (list Nat)))
    (=> (elem x xs) (elem x (append xs ys)))))
(check-sat)
