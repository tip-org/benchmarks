; Bottom-up merge sort, using a total risers function
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  risers :source Sort.risers
    ((x (list Int))) (list (list Int))
    (match x
      (case nil (_ nil (list Int)))
      (case (cons y z)
        (match z
          (case nil (cons (cons y (_ nil Int)) (_ nil (list Int))))
          (case (cons y2 xs)
            (ite
              (<= y y2)
              (match (risers z)
                (case nil (_ nil (list Int)))
                (case (cons ys yss) (cons (cons y ys) yss)))
              (cons (cons y (_ nil Int)) (risers z))))))))
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
  pairwise :source Sort.pairwise
    ((x (list (list Int)))) (list (list Int))
    (match x
      (case nil (_ nil (list Int)))
      (case (cons xs y)
        (match y
          (case nil (cons xs (_ nil (list Int))))
          (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))
(define-fun-rec
  mergingbu2 :source Sort.mergingbu2
    ((x (list (list Int)))) (list Int)
    (match x
      (case nil (_ nil Int))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu2 (pairwise x)))))))
(define-fun
  msortbu2 :source Sort.msortbu2
    ((x (list Int))) (list Int) (mergingbu2 (risers x)))
(prove
  :source Sort.prop_MSortBU2Sorts
  (forall ((xs (list Int))) (ordered (msortbu2 xs))))
