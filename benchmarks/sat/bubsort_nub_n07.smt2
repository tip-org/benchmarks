(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
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
  bubble
    ((x (list Nat))) (Pair Bool (list Nat))
    (match x
      (case nil (Pair2 false (as nil (list Nat))))
      (case (cons y z)
        (match z
          (case nil (Pair2 false (cons y (as nil (list Nat)))))
          (case (cons y2 xs)
            (ite
              (le y y2)
              (match (bubble z) (case (Pair2 b2 zs) (Pair2 b2 (cons y zs))))
              (match (bubble (cons y xs))
                (case (Pair2 c ys) (Pair2 true (cons y2 ys))))))))))
(define-fun-rec
  bubsort
    ((x (list Nat))) (list Nat)
    (match (bubble x) (case (Pair2 c ys) (ite c (bubsort ys) x))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (bubsort xs) (bubsort ys))
      (or (= xs ys)
        (or (distinct (nub xs) xs)
          (distinct (length xs) (S (S (S (S (S (S (S Z)))))))))))))
(check-sat)
