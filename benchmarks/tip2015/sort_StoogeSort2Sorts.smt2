; Stooge sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-fun-rec
  (par (a)
    (ztake
       ((x Int) (y (list a))) (list a)
       (ite
         (= x 0) (as nil (list a))
         (match y
           (case nil (as nil (list a)))
           (case (cons z xs) (cons z (ztake (- x 1) xs))))))))
(define-fun-rec
  (par (a)
    (zlength
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y xs) (+ 1 (zlength xs)))))))
(define-fun-rec
  (par (a)
    (zdrop
       ((x Int) (y (list a))) (list a)
       (ite
         (= x 0) y
         (match y
           (case nil (as nil (list a)))
           (case (cons z xs) (zdrop (- x 1) xs)))))))
(define-fun
  (par (a)
    (zsplitAt
       ((x Int) (y (list a))) (Pair (list a) (list a))
       (Pair2 (ztake x y) (zdrop x y)))))
(define-fun
  sort2
    ((x Int) (y Int)) (list Int)
    (ite
      (<= x y) (cons x (cons y (as nil (list Int))))
      (cons y (cons x (as nil (list Int))))))
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
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-funs-rec
  ((stooge2sort2 ((x (list Int))) (list Int))
   (stoogesort2 ((x (list Int))) (list Int))
   (stooge2sort1 ((x (list Int))) (list Int)))
  ((match (zsplitAt (div (+ (* 2 (zlength x)) 1) 3) x)
     (case (Pair2 ys zs) (append (stoogesort2 ys) zs)))
   (match x
     (case nil (as nil (list Int)))
     (case (cons y z)
       (match z
         (case nil (cons y (as nil (list Int))))
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (stooge2sort2 (stooge2sort1 (stooge2sort2 x)))))))))
   (match (zsplitAt (div (zlength x) 3) x)
     (case (Pair2 ys zs) (append ys (stoogesort2 zs))))))
(assert-not (forall ((x (list Int))) (ordered (stoogesort2 x))))
(check-sat)
