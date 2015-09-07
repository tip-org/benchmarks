(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (t)
    (singletons
       ((x (list t))) (list (list t))
       (match x
         (case nil (as nil (list (list t))))
         (case (cons y xs)
           (cons (cons y (as nil (list t))) (singletons xs)))))))
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
  pairwise
    ((x (list (list Nat)))) (list (list Nat))
    (match x
      (case nil (as nil (list (list Nat))))
      (case (cons xs y)
        (match y
          (case nil (cons xs (as nil (list (list Nat)))))
          (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))
(define-fun-rec
  mergingbu
    ((x (list (list Nat)))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu (pairwise x)))))))
(define-fun
  msortbu ((x (list Nat))) (list Nat) (mergingbu (singletons x)))
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
    (or (distinct (msortbu xs) (msortbu ys))
      (or (= xs ys)
        (or (distinct (nub xs) xs)
          (or
            (distinct (length xs) (S (S (S (S (S (S (S (S (S (S Z)))))))))))
            (distinct (length ys)
              (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))
(check-sat)
