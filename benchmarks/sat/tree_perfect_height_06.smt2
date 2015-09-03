(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (B (B_0 (Tree a)) (B_1 a) (B_2 (Tree a))) (E))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
(define-fun-rec
  uniqsorted
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (lt y y2) (uniqsorted z)))))))
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
  (par (a)
    (perfect
       ((x (Tree a))) Bool
       (match x
         (case (B t1 y t2)
           (and (equal (height t1) (height t2))
             (and (perfect t1) (perfect t2))))
         (case E true)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a))) (list a)
       (match x
         (case (B t1 y t2)
           (append (append (flatten t1) (cons y (as nil (list a))))
             (flatten t2)))
         (case E (as nil (list a)))))))
(define-fun ordered ((x (Tree Nat))) Bool (uniqsorted (flatten x)))
(assert-not
  (forall ((t (Tree Nat)))
    (or (not (perfect t))
      (or (not (ordered t))
        (not (equal (height t) (S (S (S (S (S (S Z))))))))))))
(check-sat)
