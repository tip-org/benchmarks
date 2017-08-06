; QuickSort
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (filter :let :source Prelude.filter
       ((p (=> a Bool)) (x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs)
           (ite (@ p y) (cons y (filter p xs)) (filter p xs)))))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  qsort :source Sort.qsort
    ((x (list Int))) (list Int)
    (match x
      (case nil (_ nil Int))
      (case (cons y xs)
        (++ (qsort (filter (lambda ((z Int)) (<= z y)) xs))
          (++ (cons y (_ nil Int))
            (qsort (filter (lambda ((x2 Int)) (> x2 y)) xs)))))))
(prove
  :source Sort.prop_QSortCount
  (forall ((x Int) (xs (list Int)))
    (= (count x (qsort xs)) (count x xs))))
