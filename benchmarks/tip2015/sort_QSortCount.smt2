; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (t)
    (filter
       ((q (=> t Bool)) (x (list t))) (list t)
       (match x
         (case nil (as nil (list t)))
         (case (cons y z)
           (ite (@ q y) (cons y (filter q z)) (filter q z)))))))
(define-fun-rec
  count
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs)))))
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
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (count x (qsort y)) (count x y))))
(check-sat)
