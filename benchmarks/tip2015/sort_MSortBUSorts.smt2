; Bottom-up merge sort
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
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
  (par (a b)
    (map :let :source Prelude.map
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (_ nil b))
         (case (cons y xs) (cons (@ f y) (map f xs)))))))
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
  mergingbu :source Sort.mergingbu
    ((x (list (list Int)))) (list Int)
    (match x
      (case nil (_ nil Int))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu (pairwise x)))))))
(define-fun
  msortbu :source Sort.msortbu
    ((x (list Int))) (list Int)
    (mergingbu (map (lambda ((y Int)) (cons y (_ nil Int))) x)))
(prove
  :source Sort.prop_MSortBUSorts
  (forall ((xs (list Int))) (ordered (msortbu xs))))
