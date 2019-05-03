; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  Tree
  (par (a)
    ((Leaf)
     (Node (proj1-Node (Tree a))
       (proj2-Node a) (proj3-Node (Tree a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  mirror
  (par (a) (((x (Tree a))) (Tree a)))
  (match x
    ((Leaf (_ Leaf a))
     ((Node l y r) (Node (mirror r) y (mirror l))))))
(define-fun-rec
  max
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z y)
     ((S z)
      (match y
        ((Z x)
         ((S x2) (S (max z x2)))))))))
(define-fun-rec
  height
  (par (a) (((x (Tree a))) Nat))
  (match x
    ((Leaf Z)
     ((Node l y r) (S (max (height l) (height r)))))))
(prove
  (par (a)
    (forall ((a1 (Tree a))) (= (height (mirror a1)) (height a1)))))
