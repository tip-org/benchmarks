; Source: IsaPlanner test suite
(declare-datatypes
  (a)
  ((Tree
     (Leaf) (Node (Node_ (Tree a)) (Node_2 a) (Node_3 (Tree a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a2) (mirror ((x (Tree a2))) (Tree a2))))
  ((match x
     (case Leaf x)
     (case
       (Node l x2 r)
       (Node (as (mirror r) (Tree a2)) x2 (as (mirror l) (Tree a2)))))))
(define-funs-rec
  ((max2 ((x3 Nat) (x4 Nat)) Nat))
  ((match x3
     (case Z x4)
     (case
       (S ipv)
       (match x4
         (case Z x3)
         (case (S ipv2) (S (max2 ipv ipv2))))))))
(define-funs-rec
  ((par (a5) (height ((x5 (Tree a5))) Nat)))
  ((match x5
     (case Leaf Z)
     (case
       (Node l2 x6 r2)
       (S (max2 (as (height l2) Nat) (as (height r2) Nat)))))))
(assert-not
  (par
    (a6)
    (forall ((a7 (Tree a6))) (= (height (mirror a7)) (height a7)))))
(check-sat)
