; Bottom-up merge sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  ordered
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (<= y y2) (ordered z)))))))
(define-fun-rec
  (par (t t2)
    (map2
       ((f (=> t2 t)) (x (list t2))) (list t)
       (match x
         (case nil (as nil (list t)))
         (case (cons y z) (cons (@ f y) (map2 f z)))))))
(define-fun-rec
  lmerge
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (ite (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))
(define-fun-rec
  pairwise
    ((x (list (list Int)))) (list (list Int))
    (match x
      (case nil (as nil (list (list Int))))
      (case (cons xs y)
        (match y
          (case nil (cons xs (as nil (list (list Int)))))
          (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))
(define-fun-rec
  mergingbu
    ((x (list (list Int)))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu (pairwise x)))))))
(define-fun
  msortbu
    ((x (list Int))) (list Int)
    (mergingbu
      (map2 (lambda ((y Int)) (cons y (as nil (list Int)))) x)))
(assert-not (forall ((x (list Int))) (ordered (msortbu x))))
(check-sat)
