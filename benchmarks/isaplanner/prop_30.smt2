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
  ((ins ((x Nat) (y (list Nat))) (list Nat)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs) (ite (lt x z) (cons x y) (cons z (ins x xs)))))))
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
(assert-not (forall ((x Nat) (xs (list Nat))) (elem x (ins x xs))))
(check-sat)
