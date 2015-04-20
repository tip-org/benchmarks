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
  ((count ((x Nat) (y (list Nat))) Nat))
  ((match y
     (case nil Z)
     (case (cons z ys)
       (ite (equal x z) (S (count x ys)) (count x ys))))))
(assert-not
  (forall ((n Nat) (x Nat) (xs (list Nat)))
    (=> (= n x) (= (S (count n xs)) (count n (cons x xs))))))
(check-sat)
