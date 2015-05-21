; Bottom-up merge sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec ((or2 ((x Bool) (y Bool)) Bool)) ((ite x true y)))
(define-funs-rec
  ((par (t) (null ((x (list t))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((par (t t2) (map2 ((f (=> t2 t)) (x (list t2))) (list t))))
  ((match x
     (case nil (as nil (list t)))
     (case (cons y z) (cons (@ f y) (map2 f z))))))
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
     (case nil x)
     (case (cons xs y)
       (match y
         (case nil x)
         (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss))))))))
(define-funs-rec
  ((mergingbu ((x (list (list Int)))) (list Int)))
  ((match x
     (case nil (as nil (list Int)))
     (case (cons xs y)
       (match y
         (case nil xs)
         (case (cons z x2) (mergingbu (pairwise x))))))))
(define-funs-rec
  ((elem ((x Int) (y (list Int))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((msortbu ((x (list Int))) (list Int)))
  ((dot (lambda ((y (list (list Int)))) (mergingbu y))
     (lambda ((z (list Int)))
       (map2 (lambda ((x2 Int)) (cons x2 (as nil (list Int)))) z))
     x)))
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list Int)) (y (list Int))) Bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not
  (forall ((x (list Int))) (isPermutation (msortbu x) x)))
(check-sat)
