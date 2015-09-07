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
  insert2
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (cons x (as nil (list Nat))))
      (case (cons z xs)
        (ite (le x z) (cons x y) (cons z (insert2 x xs))))))
(define-fun-rec
  isort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons y xs) (insert2 y (isort xs)))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (isort xs) (isort ys))
      (or (= xs ys)
        (distinct (length xs)
          (S
            (S
              (S
                (S
                  (S
                    (S
                      (S
                        (S
                          (S
                            (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))))))
(check-sat)
