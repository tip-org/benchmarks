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
    (filter
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (as nil (list a)))
         (case (cons z xs)
           (ite (@ x z) (cons z (filter x xs)) (filter x xs)))))))
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
  elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (equal x z) (elem x ys)))))
(define-fun-rec
  unique
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (not (elem y xs)) (unique xs)))))
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
          (append (qsort (filter (lambda ((z Nat)) (le z y)) xs))
            (cons y (as nil (list Nat))))
          (qsort (filter (lambda ((x2 Nat)) (gt x2 y)) xs))))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (qsort xs) (qsort ys))
      (or (= xs ys)
        (or (not (unique xs))
          (not (ge (length xs) (S (S (S (S (S (S (S (S (S Z))))))))))))))))
(check-sat)
