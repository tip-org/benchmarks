; Bottom-up merge sort, using a total risers function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  risers
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
      (case nil (_ nil (list Int)))
      (case (cons xs y)
        (match y
          (case nil (cons xs (_ nil (list Int))))
          (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))
(define-fun-rec
  mergingbu2
    ((x (list (list Int)))) (list Int)
    (match x
      (case nil (_ nil Int))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu2 (pairwise x)))))))
(define-fun
  msortbu2 ((x (list Int))) (list Int) (mergingbu2 (risers x)))
(define-fun-rec
  insert
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (cons x (_ nil Int)))
      (case (cons z xs)
        (ite (<= x z) (cons x y) (cons z (insert x xs))))))
(define-fun-rec
  isort
    ((x (list Int))) (list Int)
    (match x
      (case nil (_ nil Int))
      (case (cons y xs) (insert y (isort xs)))))
(prove (forall ((xs (list Int))) (= (msortbu2 xs) (isort xs))))
