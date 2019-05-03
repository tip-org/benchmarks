; Stooge sort defined using reverse
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  take
  (par (a) (((x Int) (y (list a))) (list a)))
  (ite
    (<= x 0) (_ nil a)
    (match y
      ((nil (_ nil a))
       ((cons z xs) (cons z (take (- x 1) xs)))))))
(define-fun
  sort2
  ((x Int) (y Int)) (list Int)
  (ite
    (<= x y) (cons x (cons y (_ nil Int)))
    (cons y (cons x (_ nil Int)))))
(define-fun-rec
  length
  (par (a) (((x (list a))) Int))
  (match x
    ((nil 0)
     ((cons y l) (+ 1 (length l))))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  drop
  (par (a) (((x Int) (y (list a))) (list a)))
  (ite
    (<= x 0) y
    (match y
      ((nil (_ nil a))
       ((cons z xs1) (drop (- x 1) xs1))))))
(define-fun
  splitAt
  (par (a) (((x Int) (y (list a))) (pair (list a) (list a))))
  (pair2 (take x y) (drop x y)))
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
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  reverse
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (++ (reverse xs) (cons y (_ nil a)))))))
(define-funs-rec
  ((stooge1sort2
    ((x (list Int))) (list Int))
   (stoogesort
    ((x (list Int))) (list Int))
   (stooge1sort1
    ((x (list Int))) (list Int)))
  ((match (splitAt (div (length x) 3) (reverse x))
     (((pair2 ys1 zs1) (++ (stoogesort zs1) (reverse ys1)))))
   (match x
     ((nil (_ nil Int))
      ((cons y z)
       (match z
         ((nil (cons y (_ nil Int)))
          ((cons y2 x2)
           (match x2
             ((nil (sort2 y y2))
              ((cons x3 x4)
               (stooge1sort2 (stooge1sort1 (stooge1sort2 x))))))))))))
   (match (splitAt (div (length x) 3) x)
     (((pair2 ys1 zs) (++ ys1 (stoogesort zs)))))))
(prove
  (forall ((xs (list Int))) (isPermutation (stoogesort xs) xs)))
