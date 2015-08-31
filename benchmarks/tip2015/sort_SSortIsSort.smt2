; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  zdelete
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys) (ite (= x z) ys (cons z (zdelete x ys))))))
(define-fun-rec
  ssort_minimum
    ((x Int) (y (list Int))) Int
    (match y
      (case nil x)
      (case (cons z ys)
        (ite (<= z x) (ssort_minimum z ys) (ssort_minimum x ys)))))
(define-fun-rec
  ssort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y ys)
        (let ((m (ssort_minimum y ys))) (cons m (ssort (zdelete m x)))))))
(define-fun-rec
  insert2
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (cons x (as nil (list Int))))
      (case (cons z xs)
        (ite (<= x z) (cons x y) (cons z (insert2 x xs))))))
(define-fun-rec
  isort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y xs) (insert2 y (isort xs)))))
(assert-not (forall ((x (list Int))) (= (ssort x) (isort x))))
(check-sat)
