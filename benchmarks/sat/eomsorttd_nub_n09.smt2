(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
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
  lmerge
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (ite (le z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))
(define-fun-rec
  ge
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z true)
      (case (S z)
        (match x
          (case Z false)
          (case (S x2) (ge x2 z))))))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (as nil (list a)))
     (case (cons y xs) (evens xs)))))
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
  eomsorttd
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons y z)
        (match z
          (case nil (cons y (as nil (list Nat))))
          (case (cons x2 x3)
            (lmerge (eomsorttd (evens x)) (eomsorttd (odds x))))))))
(define-fun-rec
  deleteAll
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (as nil (list Nat)))
      (case (cons z xs)
        (ite (equal x z) (deleteAll x xs) (cons z (deleteAll x xs))))))
(define-fun-rec
  nub
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons y xs) (cons y (deleteAll y (nub xs))))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (eomsorttd xs) (eomsorttd ys))
      (or (= xs ys)
        (or (distinct (nub xs) xs)
          (not (ge (length xs) (S (S (S (S (S (S (S (S (S Z))))))))))))))))
(check-sat)
