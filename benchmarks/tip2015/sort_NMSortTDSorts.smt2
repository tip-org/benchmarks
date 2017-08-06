; Top-down merge sort, using division by two on natural numbers
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (take :source Prelude.take
       ((x Int) (y (list a))) (list a)
       (ite
         (<= x 0) (_ nil a)
         (match y
           (case nil (_ nil a))
           (case (cons z xs) (cons z (take (- x 1) xs))))))))
(define-fun-rec
  ordered :source SortUtils.ordered
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (<= y y2) (ordered z)))))))
(define-fun-rec
  nmsorttd-half1 :let
    ((x Int)) Int
    (ite (= x 1) 0 (ite (= x 0) 0 (+ 1 (nmsorttd-half1 (- x 2))))))
(define-fun-rec
  lmerge :source Sort.lmerge
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (ite (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))
(define-fun-rec
  (par (a)
    (length :source Prelude.length
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y l) (+ 1 (length l)))))))
(define-fun-rec
  (par (a)
    (drop :source Prelude.drop
       ((x Int) (y (list a))) (list a)
       (ite
         (<= x 0) y
         (match y
           (case nil (_ nil a))
           (case (cons z xs1) (drop (- x 1) xs1)))))))
(define-fun-rec
  nmsorttd :source Sort.nmsorttd
    ((x (list Int))) (list Int)
    (match x
      (case nil (_ nil Int))
      (case (cons y z)
        (match z
          (case nil (cons y (_ nil Int)))
          (case (cons x2 x3)
            (let ((k (nmsorttd-half1 (length x))))
              (lmerge (nmsorttd (take k x)) (nmsorttd (drop k x)))))))))
(prove
  :source Sort.prop_NMSortTDSorts
  (forall ((xs (list Int))) (ordered (nmsorttd xs))))
