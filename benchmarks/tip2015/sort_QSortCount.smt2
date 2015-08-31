; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zcount
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (zcount x xs)) (zcount x xs)))))
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
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (zcount x (qsort y)) (zcount x y))))
(check-sat)
