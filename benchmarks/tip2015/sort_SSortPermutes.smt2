; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  ssort_minimum
    ((x Int) (y (list Int))) Int
    (match y
      (case nil x)
      (case (cons z ys)
        (ite (<= z x) (ssort_minimum z ys) (ssort_minimum x ys)))))
(define-fun
  (par (t)
    (null
       ((x (list t))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  elem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (elem x ys)))))
(define-fun-rec
  delete
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys) (ite (= x z) ys (cons z (delete x ys))))))
(define-fun-rec
  isPermutation
    ((x (list Int)) (y (list Int))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (and (elem z y) (isPermutation xs (delete z y))))))
(define-fun-rec
  ssort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y ys)
        (let ((m (ssort_minimum y ys))) (cons m (ssort (delete m x)))))))
(assert-not (forall ((x (list Int))) (isPermutation (ssort x) x)))
(check-sat)
