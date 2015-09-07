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
  gt
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z false)
      (case (S z)
        (match y
          (case Z true)
          (case (S x2) (gt z x2))))))
(define-fun-rec
  filter_le
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (as nil (list Nat)))
      (case (cons z ys)
        (ite (le z x) (cons z (filter_le x ys)) (filter_le x ys)))))
(define-fun-rec
  filter_gt
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (as nil (list Nat)))
      (case (cons z ys)
        (ite (gt z x) (cons z (filter_gt x ys)) (filter_gt x ys)))))
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
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  qsort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons y xs)
        (append
          (append (qsort (filter_le y xs)) (cons y (as nil (list Nat))))
          (qsort (filter_gt y xs))))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (qsort xs) (qsort ys))
      (or (= xs ys)
        (or (distinct (nub xs) xs)
          (distinct (length xs)
            (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))
(check-sat)
