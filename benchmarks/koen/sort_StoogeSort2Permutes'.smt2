; Stooge sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
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
(define-funs-rec ((or2 ((x bool) (y bool)) bool)) ((ite x true y)))
(define-funs-rec
  ((par (t) (null ((x (list t))) bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((elem ((x int) (y (list int))) bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((delete ((x int) (y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((stooge2sort2 ((x (list int))) (list int))
   (stoogesort2 ((x (list int))) (list int))
   (stooge2sort1 ((x (list int))) (list int)))
  ((match (zsplitAt (div (+ (* 2 (zlength x)) 1) 3) x)
     (case (Pair ys zs)
       (match (zsplitAt (div (+ (* 2 (zlength x)) 1) 3) x)
         (case (Pair xs zs2) (append (stoogesort2 ys) zs2)))))
   (match x
     (case nil x)
     (case (cons y z)
       (match z
         (case nil x)
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (stooge2sort2 (stooge2sort1 (stooge2sort2 x)))))))))
   (match (zsplitAt (div (zlength x) 3) x)
     (case (Pair ys zs)
       (match (zsplitAt (div (zlength x) 3) x)
         (case (Pair xs zs2) (append ys (stoogesort2 zs2))))))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list int)) (y (list int))) bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not
  (forall ((x (list int))) (isPermutation (stoogesort2 x) x)))
(check-sat)
