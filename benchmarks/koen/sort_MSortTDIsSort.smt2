; Top-down merge sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (ztake ((x Int) (y (list a))) (list a))))
  ((ite
     (= x 0) (as nil (list a))
     (match y
       (case nil (as nil (list a)))
       (case (cons z xs) (cons z (ztake (- x 1) xs)))))))
(define-funs-rec
  ((par (a) (zlength ((x (list a))) Int)))
  ((match x
     (case nil 0)
     (case (cons y xs) (+ 1 (zlength xs))))))
(define-funs-rec
  ((par (a) (zdrop ((x Int) (y (list a))) (list a))))
  ((ite
     (= x 0) y
     (match y
       (case nil (as nil (list a)))
       (case (cons z xs) (zdrop (- x 1) xs))))))
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
  ((msorttd ((x (list Int))) (list Int)))
  ((match x
     (case nil (as nil (list Int)))
     (case (cons y z)
       (match z
         (case nil (cons y (as nil (list Int))))
         (case (cons x2 x3)
           (let (((k Int) (div (zlength x) 2)))
             (lmerge (msorttd (ztake k x)) (msorttd (zdrop k x))))))))))
(define-funs-rec
  ((insert2 ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (cons x (as nil (list Int))))
     (case (cons z xs)
       (ite (<= x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list Int))) (list Int)))
  ((match x
     (case nil (as nil (list Int)))
     (case (cons y xs) (insert2 y (isort xs))))))
(assert-not (forall ((x (list Int))) (= (msorttd x) (isort x))))
(check-sat)
