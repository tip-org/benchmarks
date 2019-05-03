; QuickSort
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  filter
  (par (a) (((p (=> a Bool)) (x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (ite (@ p y) (cons y (filter p xs)) (filter p xs))))))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Int))
  (match y
    ((nil 0)
     ((cons z ys) (ite (= x z) (+ 1 (count x ys)) (count x ys))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  qsort
  ((x (list Int))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons y xs)
      (++ (qsort (filter (lambda ((z Int)) (<= z y)) xs))
        (++ (cons y (_ nil Int))
          (qsort (filter (lambda ((x2 Int)) (> x2 y)) xs))))))))
(prove
  (forall ((x Int) (xs (list Int)))
    (= (count x (qsort xs)) (count x xs))))
