; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
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
(define-fun
  (par (a)
    (null
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  zisPermutation
    ((x (list Int)) (y (list Int))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (and (zelem z y) (zisPermutation xs (zdelete z y))))))
(assert-not (forall ((x (list Int))) (zisPermutation (ssort x) x)))
(check-sat)
