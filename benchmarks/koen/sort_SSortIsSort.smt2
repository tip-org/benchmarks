; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((minimum ((x int) (y (list int))) int))
  ((match y
     (case nil x)
     (case (cons z ys) (ite (<= z x) (minimum z ys) (minimum x ys))))))
(define-funs-rec
  ((insert2 ((x int) (y (list int))) (list int)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs)
       (ite (<= x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons y xs) (insert2 y (isort xs))))))
(define-funs-rec
  ((delete ((x int) (y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((ssort ((x (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons y ys)
       (cons (minimum y ys) (ssort (delete (minimum y ys) x)))))))
(assert-not (forall ((x (list int))) (= (ssort x) (isort x))))
(check-sat)
