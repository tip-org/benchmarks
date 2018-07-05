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
  (par (a)
    (elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (_ nil a))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  (par (a)
    (isPermutation
       ((x (list a)) (y (list a))) Bool
       (match x
         (case nil
           (match y
             (case nil true)
             (case (cons z x2) false)))
         (case (cons x3 xs)
           (and (elem x3 y)
             (isPermutation xs
               (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5)))
                 x3 y))))))))
(prove (forall ((xs (list Int))) (isPermutation (msortbu2 xs) xs)))
