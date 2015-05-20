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
     (case nil (cons x y))
     (case (cons z xs)
       (ite (<= x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list Int))) (list Int)))
  ((match x
     (case nil x)
     (case (cons y xs) (insert2 y (isort xs))))))
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((ssort ((x (list Int))) (list Int)))
  ((match x
     (case nil x)
     (case (cons y ys)
       (cons (ssort_minimum y ys)
         (ssort (delete (ssort_minimum y ys) x)))))))
(assert-not (forall ((x (list Int))) (= (ssort x) (isort x))))
(check-sat)
