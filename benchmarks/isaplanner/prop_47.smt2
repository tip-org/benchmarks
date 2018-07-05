; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((Tree (Leaf)
     (Node (proj1-Node (Tree a))
       (proj2-Node a) (proj3-Node (Tree a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (mirror
       ((x (Tree a))) (Tree a)
       (match x
         (case Leaf (_ Leaf a))
         (case (Node l y r) (Node (mirror r) y (mirror l)))))))
(define-fun-rec
  max
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (S (max z x2)))))))
(define-fun-rec
  (par (a)
    (height
       ((x (Tree a))) Nat
       (match x
         (case Leaf Z)
         (case (Node l y r) (S (max (height l) (height r))))))))
(prove
  (par (a)
    (forall ((a1 (Tree a))) (= (height (mirror a1)) (height a1)))))
