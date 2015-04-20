; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((Tree (Leaf)
     (Node (Node_0 (Tree a)) (Node_1 a) (Node_2 (Tree a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (mirror ((x (Tree a))) (Tree a))))
  ((match x
     (case Leaf x)
     (case (Node l y r)
       (Node (as (mirror r) (Tree a)) y (as (mirror l) (Tree a)))))))
(define-funs-rec
  ((max2 ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z)
       (match y
         (case Z x)
         (case (S x2) (S (max2 z x2))))))))
(define-funs-rec
  ((par (a) (height ((x (Tree a))) Nat)))
  ((match x
     (case Leaf Z)
     (case (Node l y r)
       (S (max2 (as (height l) Nat) (as (height r) Nat)))))))
(assert-not
  (par (a)
    (forall ((b (Tree a))) (= (height (mirror b)) (height b)))))
(check-sat)
