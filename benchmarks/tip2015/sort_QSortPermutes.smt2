; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun
  (par (t)
    (null
       ((x (list t))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  (par (t)
    (filter
       ((p (=> t Bool)) (x (list t))) (list t)
       (match x
         (case nil (as nil (list t)))
         (case (cons y z)
           (ite (@ p y) (cons y (filter p z)) (filter p z)))))))
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
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  qsort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y xs)
        (append
          (append (qsort (filter (lambda ((z Int)) (<= z y)) xs))
            (cons y (as nil (list Int))))
          (qsort (filter (lambda ((x2 Int)) (> x2 y)) xs))))))
(assert-not (forall ((x (list Int))) (isPermutation (qsort x) x)))
(check-sat)
