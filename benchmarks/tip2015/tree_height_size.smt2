(declare-datatypes (a)
  ((Tree (B (B_0 (Tree a)) (B_1 a) (B_2 (Tree a))) (E))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(define-fun-rec
  (par (a)
    (size
       ((x (Tree a))) Nat
       (match x
         (case (B t1 y t2) (S (plus (size t1) (size t2))))
         (case E Z)))))
(define-fun-rec
  max2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (S (max2 z x2)))))))
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
  (par (a)
    (height
       ((x (Tree a))) Nat
       (match x
         (case (B t1 y t2) (S (max2 (height t1) (height t2))))
         (case E Z)))))
(assert-not
  (par (a) (forall ((t (Tree a))) (le (height t) (size t)))))
(check-sat)
