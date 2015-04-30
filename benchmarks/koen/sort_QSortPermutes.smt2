; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (t) (filter ((q (=> t bool)) (x (list t))) (list t))))
  ((match x
     (case nil x)
     (case (cons y z)
       (ite (@ q y) (cons y (filter q z)) (filter q z))))))
(define-funs-rec
  ((count ((x int) (y (list int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((qsort ((x (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons y xs)
       (append
       (append (qsort (filter (lambda ((z int)) (<= z y)) xs))
         (cons y (as nil (list int))))
         (qsort (filter (lambda ((x2 int)) (> x2 y)) xs)))))))
(assert-not
  (forall ((x int) (y (list int)))
    (= (count x (qsort y)) (count x y))))
(check-sat)
