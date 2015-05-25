; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((ssort_minimum ((x Int) (y (list Int))) Int))
  ((match y
     (case nil x)
     (case (cons z ys)
       (ite (<= z x) (ssort_minimum z ys) (ssort_minimum x ys))))))
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
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (as nil (list Int)))
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((ssort ((x (list Int))) (list Int)))
  ((match x
     (case nil (as nil (list Int)))
     (case (cons y ys)
       (let (((m Int) (ssort_minimum y ys)))
         (cons m (ssort (delete m x))))))))
(assert-not (forall ((x (list Int))) (= (ssort x) (isort x))))
(check-sat)
