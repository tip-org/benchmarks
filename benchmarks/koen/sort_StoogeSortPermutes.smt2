; Stooge sort defined using reverse
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (ztake ((x int) (y (list a))) (list a))))
  ((ite
     (= x 0) (as nil (list a))
     (match y
       (case nil y)
       (case (cons z xs) (cons z (ztake (- x 1) xs)))))))
(define-funs-rec
  ((par (a) (zlength ((x (list a))) int)))
  ((match x
     (case nil 0)
     (case (cons y xs) (+ 1 (zlength xs))))))
(define-funs-rec
  ((par (a) (zdrop ((x int) (y (list a))) (list a))))
  ((ite
     (= x 0) y
     (match y
       (case nil y)
       (case (cons z xs) (zdrop (- x 1) xs))))))
(define-funs-rec
  ((par (a)
     (zsplitAt ((x int) (y (list a))) (Pair2 (list a) (list a)))))
  ((Pair (ztake x y) (zdrop x y))))
(define-funs-rec
  ((sort2 ((x int) (y int)) (list int)))
  ((ite
     (<= x y) (cons x (cons y (as nil (list int))))
     (cons y (cons x (as nil (list int)))))))
(define-funs-rec
  ((count ((x int) (y (list int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
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
  ((stooge1sort2 ((x (list int))) (list int))
   (stoogesort ((x (list int))) (list int))
   (stooge1sort1 ((x (list int))) (list int)))
  ((match (zsplitAt (div (zlength x) 3) (reverse x))
     (case (Pair ys zs)
       (match (zsplitAt (div (zlength x) 3) (reverse x))
         (case (Pair xs zs2) (append (stoogesort zs) (reverse xs))))))
   (match x
     (case nil x)
     (case (cons y z)
       (match z
         (case nil x)
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (stooge1sort2 (stooge1sort1 (stooge1sort2 x)))))))))
   (match (zsplitAt (div (zlength x) 3) x)
     (case (Pair ys zs)
       (match (zsplitAt (div (zlength x) 3) x)
         (case (Pair xs zs2) (append ys (stoogesort zs2))))))))
(assert-not
  (forall ((x int) (y (list int)))
    (= (count x (stoogesort y)) (count x y))))
(check-sat)