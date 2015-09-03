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
  diff
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z x)
      (case (S z)
        (match x
          (case Z y)
          (case (S x2) (diff x2 z))))))
(define-fun-rec
  (par (a)
    (bal
       ((x (Tree a))) Nat
       (match x
         (case (B t1 y t2)
           (plus (plus (diff (height t1) (height t2)) (bal t1)) (bal t2)))
         (case E Z)))))
(define-fun
  (par (a) (balanced ((x (Tree a))) Bool (le (bal x) (S (S Z))))))
(assert-not
  (par (a)
    (forall ((t (Tree a)))
      (or (not (balanced t))
        (not
          (equal (height t)
            (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))
(check-sat)
