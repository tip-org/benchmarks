; Stooge sort, using thirds on natural numbers
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun
  (par (a)
    (sort2
       ((x a) (y a)) (list a)
       (ite
         (<= x y) (cons x (cons y (as nil (list a))))
         (cons y (cons x (as nil (list a))))))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  (par (a)
    (ordered-ordered1
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z)
           (match z
             (case nil true)
             (case (cons y2 xs) (and (<= y y2) (ordered-ordered1 z)))))))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (match y (case (S y2) (minus z y2))))))
(define-fun-rec
  third
    ((x Nat)) Nat
    (ite
      (= x (S (S Z))) Z
      (ite
        (= x (S Z)) Z
        (match x
          (case Z Z)
          (case (S y) (plus (S Z) (third (minus x (S (S (S Z)))))))))))
(define-fun-rec
  twoThirds
    ((x Nat)) Nat
    (ite
      (= x (S (S Z))) (S Z)
      (ite
        (= x (S Z)) (S Z)
        (match x
          (case Z Z)
          (case (S y)
            (plus (S (S Z)) (twoThirds (minus x (S (S (S Z)))))))))))
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
    (drop
       ((x Nat) (y (list a))) (list a)
       (ite
         (le x Z) y
         (match y
           (case nil (as nil (list a)))
           (case (cons z xs1) (match x (case (S x2) (drop x2 xs1)))))))))
(define-fun
  (par (a)
    (splitAt
       ((x Nat) (y (list a))) (pair (list a) (list a))
       (pair2 (take x y) (drop x y)))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((nstooge2sort2 ((x (list Nat))) (list Nat))
   (nstoogesort2 ((x (list Nat))) (list Nat))
   (nstooge2sort1 ((x (list Nat))) (list Nat)))
  ((match (splitAt (twoThirds (length x)) x)
     (case (pair2 ys2 zs1) (++ (nstoogesort2 ys2) zs1)))
   (match x
     (case nil (as nil (list Nat)))
     (case (cons y z)
       (match z
         (case nil (cons y (as nil (list Nat))))
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (nstooge2sort2 (nstooge2sort1 (nstooge2sort2 x)))))))))
   (match (splitAt (third (length x)) x)
     (case (pair2 ys2 zs1) (++ ys2 (nstoogesort2 zs1))))))
(assert-not
  (forall ((x (list Nat))) (ordered-ordered1 (nstoogesort2 x))))
(check-sat)
