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
(assert-not
  (forall ((x Int) (xs (list Int)) (ys (list Int)))
    (=> (zelem x xs) (=> (zisPermutation xs ys) (zelem x ys)))))
(check-sat)
