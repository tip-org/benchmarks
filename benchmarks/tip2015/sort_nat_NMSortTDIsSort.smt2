; Top-down merge sort, using division by two on natural numbers
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (match y (case (S y2) (minus z y2))))))
(define-fun-rec
  nmsorttd-half1
    ((x Nat)) Nat
    (ite
      (= x (S Z)) Z
      (match x
        (case Z Z)
        (case (S y) (plus (S Z) (nmsorttd-half1 (minus x (S (S Z)))))))))
(define-fun-rec
  (par (a)
    (lmerge
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z x2)
           (match y
             (case nil x)
             (case (cons x3 x4)
               (ite
                 (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y l) (plus (S Z) (length l)))))))
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
    (take
       ((x Nat) (y (list a))) (list a)
       (ite
         (le x Z) (as nil (list a))
         (match y
           (case nil (as nil (list a)))
           (case (cons z xs)
             (match x (case (S x2) (cons z (take x2 xs))))))))))
(define-fun-rec
  (par (a)
    (insert2
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (cons x (as nil (list a))))
         (case (cons z xs)
           (ite (<= x z) (cons x y) (cons z (insert2 x xs))))))))
(define-fun-rec
  (par (a)
    (isort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (insert2 y (isort xs)))))))
(define-fun-rec
  (par (a)
    (drop
       ((x Nat) (y (list a))) (list a)
       (ite
         (le x Z) y
         (match y
           (case nil (as nil (list a)))
           (case (cons z xs1) (match x (case (S x2) (drop x2 xs1)))))))))
(define-fun-rec
  (par (a)
    (nmsorttd
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y z)
           (match z
             (case nil (cons y (as nil (list a))))
             (case (cons x2 x3)
               (let ((k (nmsorttd-half1 (length x))))
                 (lmerge (nmsorttd (take k x)) (nmsorttd (drop k x)))))))))))
(assert-not (forall ((x (list Nat))) (= (nmsorttd x) (isort x))))
(check-sat)
