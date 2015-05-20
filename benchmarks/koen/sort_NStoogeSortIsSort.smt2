; Stooge sort defined using reverse and thirds on natural numbers
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
(define-funs-rec
  ((par (t) (length ((x (list t))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (length xs))))))
(define-funs-rec
  ((insert2 ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs)
       (ite (<= x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list Int))) (list Int)))
  ((match x
     (case nil x)
     (case (cons y xs) (insert2 y (isort xs))))))
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
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((par (t) (reverse ((x (list t))) (list t))))
  ((match x
     (case nil x)
     (case (cons y xs)
       (append (reverse xs) (cons y (as nil (list t))))))))
(define-funs-rec
  ((nstooge1sort2 ((x (list Int))) (list Int))
   (nstoogesort ((x (list Int))) (list Int))
   (nstooge1sort1 ((x (list Int))) (list Int)))
  ((match (splitAt (third (length x)) (reverse x))
     (case (Pair2 ys zs)
       (match (splitAt (third (length x)) (reverse x))
         (case (Pair2 xs zs2) (append (nstoogesort zs) (reverse xs))))))
   (match x
     (case nil x)
     (case (cons y z)
       (match z
         (case nil x)
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (nstooge1sort2 (nstooge1sort1 (nstooge1sort2 x)))))))))
   (match (splitAt (third (length x)) x)
     (case (Pair2 ys zs)
       (match (splitAt (third (length x)) x)
         (case (Pair2 xs zs2) (append ys (nstoogesort zs2))))))))
(assert-not
  (forall ((x (list Int))) (= (nstoogesort x) (isort x))))
(check-sat)
