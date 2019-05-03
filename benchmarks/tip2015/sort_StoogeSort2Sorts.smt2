; Stooge sort
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
  ordered
  ((x (list Int))) Bool
  (match x
    ((nil true)
     ((cons y z)
      (match z
        ((nil true)
         ((cons y2 xs) (and (<= y y2) (ordered z)))))))))
(define-fun-rec
  length
  (par (a) (((x (list a))) Int))
  (match x
    ((nil 0)
     ((cons y l) (+ 1 (length l))))))
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
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-funs-rec
  ((stooge2sort2
    ((x (list Int))) (list Int))
   (stoogesort2
    ((x (list Int))) (list Int))
   (stooge2sort1
    ((x (list Int))) (list Int)))
  ((match (splitAt (div (+ (* 2 (length x)) 1) 3) x)
     (((pair2 ys1 zs) (++ (stoogesort2 ys1) zs))))
   (match x
     ((nil (_ nil Int))
      ((cons y z)
       (match z
         ((nil (cons y (_ nil Int)))
          ((cons y2 x2)
           (match x2
             ((nil (sort2 y y2))
              ((cons x3 x4)
               (stooge2sort2 (stooge2sort1 (stooge2sort2 x))))))))))))
   (match (splitAt (div (length x) 3) x)
     (((pair2 ys1 zs) (++ ys1 (stoogesort2 zs)))))))
(prove (forall ((xs (list Int))) (ordered (stoogesort2 xs))))
