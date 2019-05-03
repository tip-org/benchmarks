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
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  deleteBy
  (par (a) (((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)))
  (match z
    ((nil (_ nil a))
     ((cons y2 ys)
      (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys)))))))
(define-fun-rec
  isPermutation
  (par (a) (((x (list a)) (y (list a))) Bool))
  (match x
    ((nil
      (match y
        ((nil true)
         ((cons z x2) false))))
     ((cons x3 xs)
      (and (elem x3 y)
        (isPermutation xs
          (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5))) x3 y)))))))
(prove (forall ((xs (list Int))) (isPermutation (msortbu2 xs) xs)))
