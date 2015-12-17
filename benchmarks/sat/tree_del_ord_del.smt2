; From the reach article
;
; ordWrong does not recurse into its subtrees
(declare-datatypes (a)
  ((Tree (Empty)
     (Node (Node_0 a) (Node_1 (Tree a)) (Node_2 (Tree a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  gt
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z false)
      (case (S z)
        (match y
          (case Z true)
          (case (S x2) (gt z x2))))))
(define-fun-rec
  ge
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z true)
      (case (S z)
        (match x
          (case Z false)
          (case (S x2) (ge x2 z))))))
(define-fun-rec
  (par (a)
    (ext
       ((x (Tree a)) (y (Tree a))) (Tree a)
       (match x
         (case Empty y)
         (case (Node c t0 t1) (Node c t0 (ext t1 y)))))))
(define-fun-rec
  del
    ((x Nat) (y (Tree Nat))) (Tree Nat)
    (match y
      (case Empty (as Empty (Tree Nat)))
      (case (Node b t0 t1)
        (ite
          (lt x b) (Node b (del x t0) t1)
          (ite (gt x b) (Node b t0 (del x t1)) (ext t0 t1))))))
(define-fun-rec
  allLe
    ((x Nat) (y (Tree Nat))) Bool
    (match y
      (case Empty true)
      (case (Node b t0 t1)
        (and (le b x) (and (allLe x t0) (allLe x t1))))))
(define-fun-rec
  allGe
    ((x Nat) (y (Tree Nat))) Bool
    (match y
      (case Empty true)
      (case (Node b t0 t1)
        (and (ge b x) (and (allGe x t0) (allGe x t1))))))
(define-fun
  ordWrong
    ((x (Tree Nat))) Bool
    (match x
      (case Empty true)
      (case (Node b t0 t1) (and (allLe b t0) (allGe b t1)))))
(assert-not
  (forall ((a Nat) (t (Tree Nat)))
    (=> (ordWrong t) (ordWrong (del a t)))))
(check-sat)
