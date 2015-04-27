; Bitonic sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
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
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil x)
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil x)
     (case (cons y xs) (evens xs)))))
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
  ((pairs ((x (list int)) (y (list int))) (list int)))
  ((match x
     (case nil y)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4) (append (sort2 z x3) (pairs x2 x4))))))))
(define-funs-rec
  ((stitch ((x (list int)) (y (list int))) (list int)))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (pairs xs y))))))
(define-funs-rec
  ((bmerge ((x (list int)) (y (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4)
           (match x2
             (case nil
               (match x4
                 (case nil (sort2 z x3))
                 (case (cons x5 x6)
                   (stitch (bmerge (evens x) (evens y)) (bmerge (odds x) (odds y))))))
             (case (cons x7 x8)
               (stitch (bmerge (evens x) (evens y))
                 (bmerge (odds x) (odds y)))))))))))
(define-funs-rec
  ((bsort ((x (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons y z)
       (match z
         (case nil x)
         (case (cons x2 x3)
           (bmerge (bsort (evens x)) (bsort (odds x)))))))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list int)) (y (list int))) bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not (forall ((x (list int))) (isPermutation (bsort x) x)))
(check-sat)
