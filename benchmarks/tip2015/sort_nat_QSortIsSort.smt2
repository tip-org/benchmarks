; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (insert2
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (cons x (as nil (list a))))
         (case (cons z xs)
           (ite (<= x z) (cons x y) (cons z (insert2 x xs))))))))
(define-fun-rec
  (par (a)
    (isort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (insert2 y (isort xs)))))))
(define-fun-rec
  (par (a)
    (filter
       ((q (=> a Bool)) (x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs)
           (ite (@ q y) (cons y (filter q xs)) (filter q xs)))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (qsort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs)
           (++ (qsort (filter (lambda ((z a)) (<= z y)) xs))
             (++ (cons y (as nil (list a)))
               (qsort (filter (lambda ((x2 a)) (> x2 y)) xs)))))))))
(assert-not (forall ((x (list Nat))) (= (qsort x) (isort x))))
(check-sat)
