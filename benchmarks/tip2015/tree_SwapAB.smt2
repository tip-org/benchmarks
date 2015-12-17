(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (Node (Node_0 (Tree a)) (Node_1 a) (Node_2 (Tree a)))
     (Nil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun-rec
  swap
    ((x Nat) (y Nat) (z (Tree Nat))) (Tree Nat)
    (match z
      (case (Node q x2 r)
        (ite
          (equal x2 x) (Node (swap x y q) y (swap x y r))
          (ite
            (equal x2 y) (Node (swap x y q) x (swap x y r))
            (Node (swap x y q) x2 (swap x y r)))))
      (case Nil (as Nil (Tree Nat)))))
(define-fun-rec
  elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (equal x z) (elem x ys)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a)
    (flatten0
       ((x (Tree a))) (list a)
       (match x
         (case (Node q y r)
           (append (append (flatten0 q) (cons y (as nil (list a))))
             (flatten0 r)))
         (case Nil (as nil (list a)))))))
(assert-not
  (forall ((q (Tree Nat)) (a Nat) (b Nat))
    (=> (elem a (flatten0 q))
      (=> (elem b (flatten0 q))
        (and (elem a (flatten0 (swap a b q)))
          (elem b (flatten0 (swap a b q))))))))
(check-sat)
