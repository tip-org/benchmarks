; Stooge sort, using thirds on natural numbers
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
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
  ((sort2 ((x int) (y int)) (list int)))
  ((ite
     (<= x y) (cons x (cons y (as nil (list int))))
     (cons y (cons x (as nil (list int)))))))
(define-funs-rec
  ((par (t) (length ((x (list t))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (length xs))))))
(define-funs-rec
  ((insert2 ((x int) (y (list int))) (list int)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs)
       (ite (<= x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list int))) (list int)))
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
     (splitAt ((x Nat) (y (list a))) (Pair2 (list a) (list a)))))
  ((Pair (take x y) (drop x y))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((nstooge2sort2 ((x (list int))) (list int))
   (nstoogesort2 ((x (list int))) (list int))
   (nstooge2sort1 ((x (list int))) (list int)))
  ((match (splitAt (twoThirds (length x)) x)
     (case (Pair ys zs)
       (match (splitAt (twoThirds (length x)) x)
         (case (Pair xs zs2) (append (nstoogesort2 ys) zs2)))))
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
     (case (Pair ys zs)
       (match (splitAt (third (length x)) x)
         (case (Pair xs zs2) (append ys (nstoogesort2 zs2))))))))
(assert-not
  (forall ((x (list int))) (= (nstoogesort2 x) (isort x))))
(check-sat)
