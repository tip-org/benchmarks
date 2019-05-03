; Bottom-up merge sort, using a total risers function
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  risers
  ((x (list Int))) (list (list Int))
  (match x
    ((nil (_ nil (list Int)))
     ((cons y z)
      (match z
        ((nil (cons (cons y (_ nil Int)) (_ nil (list Int))))
         ((cons y2 xs)
          (ite
            (<= y y2)
            (match (risers z)
              ((nil (_ nil (list Int)))
               ((cons ys yss) (cons (cons y ys) yss))))
            (cons (cons y (_ nil Int)) (risers z))))))))))
(define-fun-rec
  lmerge
  ((x (list Int)) (y (list Int))) (list Int)
  (match x
    ((nil y)
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4)
          (ite
            (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  pairwise
  ((x (list (list Int)))) (list (list Int))
  (match x
    ((nil (_ nil (list Int)))
     ((cons xs y)
      (match y
        ((nil (cons xs (_ nil (list Int))))
         ((cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))))
(define-fun-rec
  mergingbu2
  ((x (list (list Int)))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons xs y)
      (match y
        ((nil xs)
         ((cons z x2) (mergingbu2 (pairwise x)))))))))
(define-fun
  msortbu2
  ((x (list Int))) (list Int) (mergingbu2 (risers x)))
(define-fun-rec
  insert
  ((x Int) (y (list Int))) (list Int)
  (match y
    ((nil (cons x (_ nil Int)))
     ((cons z xs) (ite (<= x z) (cons x y) (cons z (insert x xs)))))))
(define-fun-rec
  isort
  ((x (list Int))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons y xs) (insert y (isort xs))))))
(prove (forall ((xs (list Int))) (= (msortbu2 xs) (isort xs))))
