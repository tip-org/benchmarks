; Bottom-up merge sort, using a total risers function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((risers ((x (list Int))) (list (list Int))))
  ((match x
     (case nil (as nil (list (list Int))))
     (case (cons y z)
       (match z
         (case nil
           (cons (cons y (as nil (list Int))) (as nil (list (list Int)))))
         (case (cons y2 xs)
           (ite
             (<= y y2)
             (match (risers z)
               (case nil (as nil (list (list Int))))
               (case (cons ys yss) (cons (cons y ys) yss)))
             (cons (cons y (as nil (list Int))) (risers z)))))))))
(define-funs-rec
  ((par (t) (null ((x (list t))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((lmerge ((x (list Int)) (y (list Int))) (list Int)))
  ((match x
     (case nil y)
     (case (cons z x2)
       (match y
         (case nil x)
         (case (cons x3 x4)
           (ite
             (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4)))))))))
(define-funs-rec
  ((pairwise ((x (list (list Int)))) (list (list Int))))
  ((match x
     (case nil (as nil (list (list Int))))
     (case (cons xs y)
       (match y
         (case nil (cons xs (as nil (list (list Int)))))
         (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss))))))))
(define-funs-rec
  ((mergingbu2 ((x (list (list Int)))) (list Int)))
  ((match x
     (case nil (as nil (list Int)))
     (case (cons xs y)
       (match y
         (case nil xs)
         (case (cons z x2) (mergingbu2 (pairwise x))))))))
(define-funs-rec
  ((msortbu2 ((x (list Int))) (list Int))) ((mergingbu2 (risers x))))
(define-funs-rec
  ((elem ((x Int) (y (list Int))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or (= x z) (elem x ys))))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (as nil (list Int)))
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((isPermutation ((x (list Int)) (y (list Int))) Bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and (elem z y) (isPermutation xs (delete z y)))))))
(assert-not
  (forall ((x (list Int))) (isPermutation (msortbu2 x) x)))
(check-sat)
