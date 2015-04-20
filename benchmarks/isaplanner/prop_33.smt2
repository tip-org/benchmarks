; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((min2 ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S z)
       (match y
         (case Z y)
         (case (S y1) (S (min2 z y1))))))))
(define-funs-rec
  ((le ((x Nat) (y Nat)) bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (le z x2)))))))
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
(assert-not
  (forall ((a Nat) (b Nat)) (= (equal (min2 a b) a) (le a b))))
(check-sat)
