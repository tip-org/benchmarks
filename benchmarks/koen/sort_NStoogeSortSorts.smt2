; Stooge sort defined using reverse and thirds on natural numbers
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
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
  ((par (t) (reverse ((x (list t))) (list t))))
  ((match x
     (case nil x)
     (case (cons y xs)
       (append (reverse xs) (cons y (as nil (list t))))))))
(define-funs-rec
  ((nstooge1sort2 ((x (list int))) (list int))
   (nstoogesort ((x (list int))) (list int))
   (nstooge1sort1 ((x (list int))) (list int)))
  ((match (splitAt (third (length x)) (reverse x))
     (case (Pair ys zs)
       (match (splitAt (third (length x)) (reverse x))
         (case (Pair xs zs2) (append (nstoogesort zs) (reverse xs))))))
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
     (case (Pair ys zs)
       (match (splitAt (third (length x)) x)
         (case (Pair xs zs2) (append ys (nstoogesort zs2))))))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((ordered ((x (list int))) bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 xs) (and2 (<= y y2) (ordered z))))))))
(assert-not (forall ((x (list int))) (ordered (nstoogesort x))))
(check-sat)
