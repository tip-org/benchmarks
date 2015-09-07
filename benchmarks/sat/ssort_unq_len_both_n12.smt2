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
  ssort_minimum
    ((x Nat) (y (list Nat))) Nat
    (match y
      (case nil x)
      (case (cons z ys)
        (ite (le z x) (ssort_minimum z ys) (ssort_minimum x ys)))))
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
  delete
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (as nil (list Nat)))
      (case (cons z xs) (ite (equal x z) xs (cons z (delete x xs))))))
(define-fun-rec
  ssort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons y ys)
        (let ((m (ssort_minimum y ys))) (cons m (ssort (delete m x)))))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (ssort xs) (ssort ys))
      (or (= xs ys)
        (or (not (unique xs))
          (or
            (distinct (length xs)
              (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))
            (distinct (length ys)
              (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))
(check-sat)
