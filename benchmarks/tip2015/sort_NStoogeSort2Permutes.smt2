; Stooge sort, using thirds on natural numbers
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
(define-fun-rec
  zdelete
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys) (ite (= x z) ys (cons z (zdelete x ys))))))
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
(define-fun
  sort2
    ((x Int) (y Int)) (list Int)
    (ite
      (<= x y) (cons x (cons y (as nil (list Int))))
      (cons y (cons x (as nil (list Int))))))
(define-fun
  (par (a)
    (null
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  zisPermutation
    ((x (list Int)) (y (list Int))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (and (zelem z y) (zisPermutation xs (zdelete z y))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
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
  ((nstooge2sort2 ((x (list Int))) (list Int))
   (nstoogesort2 ((x (list Int))) (list Int))
   (nstooge2sort1 ((x (list Int))) (list Int)))
  ((match (splitAt (twoThirds (length x)) x)
     (case (Pair2 ys zs) (append (nstoogesort2 ys) zs)))
   (match x
     (case nil (as nil (list Int)))
     (case (cons y z)
       (match z
         (case nil (cons y (as nil (list Int))))
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (nstooge2sort2 (nstooge2sort1 (nstooge2sort2 x)))))))))
   (match (splitAt (third (length x)) x)
     (case (Pair2 ys zs) (append ys (nstoogesort2 zs))))))
(assert-not
  (forall ((x (list Int))) (zisPermutation (nstoogesort2 x) x)))
(check-sat)
