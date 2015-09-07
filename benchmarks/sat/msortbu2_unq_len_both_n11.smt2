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
  pairwise
    ((x (list (list Nat)))) (list (list Nat))
    (match x
      (case nil (as nil (list (list Nat))))
      (case (cons xs y)
        (match y
          (case nil (cons xs (as nil (list (list Nat)))))
          (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))
(define-fun-rec
  mergingbu2
    ((x (list (list Nat)))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu2 (pairwise x)))))))
(define-fun-rec
  risers
    ((x (list Nat))) (list (list Nat))
    (match x
      (case nil (as nil (list (list Nat))))
      (case (cons y z)
        (match z
          (case nil
            (cons (cons y (as nil (list Nat))) (as nil (list (list Nat)))))
          (case (cons y2 xs)
            (ite
              (le y y2)
              (match (risers z)
                (case nil (as nil (list (list Nat))))
                (case (cons ys yss) (cons (cons y ys) yss)))
              (cons (cons y (as nil (list Nat))) (risers z))))))))
(define-fun
  msortbu2 ((x (list Nat))) (list Nat) (mergingbu2 (risers x)))
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
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (msortbu2 xs) (msortbu2 ys))
      (or (= xs ys)
        (or (not (unique xs))
          (or
            (distinct (length xs)
              (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))
            (distinct (length ys)
              (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))
(check-sat)
