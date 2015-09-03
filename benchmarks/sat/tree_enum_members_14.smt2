(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
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
  gt
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z false)
      (case (S z)
        (match y
          (case Z true)
          (case (S x2) (gt z x2))))))
(define-fun-rec
  member
    ((x Nat) (y (Tree Nat))) Bool
    (match y
      (case (B l z r)
        (ite (lt x z) (member x l) (=> (gt x z) (member x r))))
      (case E false)))
(define-fun-rec
  members
    ((x (list Nat)) (y (Tree Nat))) Bool
    (match x
      (case nil true)
      (case (cons z xs) (and (member z y) (members xs y)))))
(define-fun-rec
  enum
    ((x Nat)) (list Nat)
    (match x
      (case Z (as nil (list Nat)))
      (case (S n) (cons n (enum n)))))
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
    (or (not (balanced t))
      (or (not (ordered t))
        (not
          (members
            (enum (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))
            t))))))
(check-sat)
