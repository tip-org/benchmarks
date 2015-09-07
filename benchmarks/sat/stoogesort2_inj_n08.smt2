(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  twoThirds
    ((x Nat)) Nat
    (match x
      (case Z Z)
      (case (S y)
        (match y
          (case Z (S Z))
          (case (S z)
            (match z
              (case Z (S Z))
              (case (S n) (S (S (twoThirds n))))))))))
(define-fun-rec
  third
    ((x Nat)) Nat
    (match x
      (case Z Z)
      (case (S y)
        (match y
          (case Z Z)
          (case (S z)
            (match z
              (case Z Z)
              (case (S n) (S (third n)))))))))
(define-fun-rec
  (par (a)
    (take
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z (as nil (list a)))
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons x2 x3) (cons x2 (take z x3)))))))))
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
(define-fun
  sort2
    ((x Nat) (y Nat)) (list Nat)
    (ite
      (le x y) (cons x (cons y (as nil (list Nat))))
      (cons y (cons x (as nil (list Nat))))))
(define-fun-rec
  (par (a)
    (drop
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons x2 x3) (drop z x3))))))))
(define-fun
  (par (a)
    (splitAt
       ((x Nat) (y (list a))) (Pair (list a) (list a))
       (Pair2 (take x y) (drop x y)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-funs-rec
  ((stooge2sort2 ((x (list Nat))) (list Nat))
   (stoogesort2 ((x (list Nat))) (list Nat))
   (stooge2sort1 ((x (list Nat))) (list Nat)))
  ((match (splitAt (twoThirds (length x)) x)
     (case (Pair2 ys zs) (append (stoogesort2 ys) zs)))
   (match x
     (case nil (as nil (list Nat)))
     (case (cons y z)
       (match z
         (case nil (cons y (as nil (list Nat))))
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (stooge2sort2 (stooge2sort1 (stooge2sort2 x)))))))))
   (match (splitAt (third (length x)) x)
     (case (Pair2 ys zs) (append ys (stoogesort2 zs))))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (stoogesort2 xs) (stoogesort2 ys))
      (or (= xs ys)
        (distinct (length xs) (S (S (S (S (S (S (S (S Z)))))))))))))
(check-sat)
