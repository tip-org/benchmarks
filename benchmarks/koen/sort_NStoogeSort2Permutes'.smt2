; Stooge sort, using thirds on natural numbers
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((twoThirds ((x Nat)) Nat))
  ((match x
     (case Z x)
     (case (S y)
       (match y
         (case Z x)
         (case (S z)
           (match z
             (case Z y)
             (case (S n) (S (S (twoThirds n)))))))))))
(define-funs-rec
  ((third ((x Nat)) Nat))
  ((match x
     (case Z x)
     (case (S y)
       (match y
         (case Z y)
         (case (S z)
           (match z
             (case Z z)
             (case (S n) (S (third n))))))))))
(define-funs-rec
  ((par (a) (take ((x Nat) (y (list a))) (list a))))
  ((match x
     (case Z (as nil (list a)))
     (case (S z)
       (match y
         (case nil y)
         (case (cons x2 x3) (cons x2 (take z x3))))))))
(define-funs-rec
  ((sort2 ((x Int) (y Int)) (list Int)))
  ((ite
     (<= x y) (cons x (cons y (as nil (list Int))))
     (cons y (cons x (as nil (list Int)))))))
(define-funs-rec ((or2 ((x Bool) (y Bool)) Bool)) ((ite x true y)))
(define-funs-rec
  ((par (t) (null ((x (list t))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((par (t) (length ((x (list t))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (length xs))))))
(define-funs-rec
  ((elem ((x Int) (y (list Int))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((par (a) (drop ((x Nat) (y (list a))) (list a))))
  ((match x
     (case Z y)
     (case (S z)
       (match y
         (case nil y)
         (case (cons x2 x3) (drop z x3)))))))
(define-funs-rec
  ((par (a)
     (splitAt ((x Nat) (y (list a))) (Pair (list a) (list a)))))
  ((Pair2 (take x y) (drop x y))))
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((nstooge2sort2 ((x (list Int))) (list Int))
   (nstoogesort2 ((x (list Int))) (list Int))
   (nstooge2sort1 ((x (list Int))) (list Int)))
  ((match (splitAt (twoThirds (length x)) x)
     (case (Pair2 ys zs)
       (match (splitAt (twoThirds (length x)) x)
         (case (Pair2 xs zs2) (append (nstoogesort2 ys) zs2)))))
   (match x
     (case nil x)
     (case (cons y z)
       (match z
         (case nil x)
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (nstooge2sort2 (nstooge2sort1 (nstooge2sort2 x)))))))))
   (match (splitAt (third (length x)) x)
     (case (Pair2 ys zs)
       (match (splitAt (third (length x)) x)
         (case (Pair2 xs zs2) (append ys (nstoogesort2 zs2))))))))
(define-funs-rec
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list Int)) (y (list Int))) Bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not
  (forall ((x (list Int))) (isPermutation (nstoogesort2 x) x)))
(check-sat)
