; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  zordered
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (<= y y2) (zordered z)))))))
(define-fun-rec
  (par (a)
    (filter
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (as nil (list a)))
         (case (cons z xs)
           (ite (@ x z) (cons z (filter x xs)) (filter x xs)))))))
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
(assert-not (forall ((x (list Int))) (zordered (qsort x))))
(check-sat)
