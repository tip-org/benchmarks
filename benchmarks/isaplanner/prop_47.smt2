; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((Tree :source Definitions.Tree (Leaf :source Definitions.Leaf)
     (Node :source Definitions.Node (proj1-Node (Tree a))
       (proj2-Node a) (proj3-Node (Tree a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (mirror :source Definitions.mirror
       ((x (Tree a))) (Tree a)
       (match x
         (case Leaf (as Leaf (Tree a)))
         (case (Node l y r) (Node (mirror r) y (mirror l)))))))
(define-fun-rec
  max :source Definitions.max
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (S (max z x2)))))))
(define-fun-rec
  (par (a)
    (height :source Definitions.height
       ((x (Tree a))) Nat
       (match x
         (case Leaf Z)
         (case (Node l y r) (S (max (height l) (height r))))))))
(prove
  :source Properties.prop_47
  (par (a)
    (forall ((a1 (Tree a))) (= (height (mirror a1)) (height a1)))))
