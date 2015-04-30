; Bottom-up merge sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec ((or2 ((x bool) (y bool)) bool)) ((ite x true y)))
(define-funs-rec
  ((par (t) (null ((x (list t))) bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((par (t t2) (map2 ((f (=> t2 t)) (x (list t2))) (list t))))
  ((match x
     (case nil (as nil (list t)))
     (case (cons y z) (cons (@ f y) (map2 f z))))))
(define-funs-rec
  ((lmerge ((x (list int)) (y (list int))) (list int)))
  ((match x
     (case nil y)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4)
           (ite
             (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4)))))))))
(define-funs-rec
  ((pairwise ((x (list (list int)))) (list (list int))))
  ((match x
     (case nil x)
     (case (cons xs y)
       (match y
         (case nil x)
         (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss))))))))
(define-funs-rec
  ((mergingbu ((x (list (list int)))) (list int)))
  ((match x
     (case nil (as nil (list int)))
     (case (cons xs y)
       (match y
         (case nil xs)
         (case (cons z x2) (mergingbu (pairwise x))))))))
(define-funs-rec
  ((elem ((x int) (y (list int))) bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((msortbu ((x (list int))) (list int)))
  ((dot (lambda ((y (list (list int)))) (mergingbu y))
     (lambda ((z (list int)))
       (map2 (lambda ((x2 int)) (cons x2 (as nil (list int)))) z))
     x)))
(define-funs-rec
  ((delete ((x int) (y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list int)) (y (list int))) bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not
  (forall ((x (list int))) (isPermutation (msortbu x) x)))
(check-sat)
