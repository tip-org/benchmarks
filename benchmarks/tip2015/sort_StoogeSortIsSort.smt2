; Stooge sort defined using reverse
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (take
       ((x Int) (y (list a))) (list a)
       (ite
         (<= x 0) (as nil (list a))
         (match y
           (case nil (as nil (list a)))
           (case (cons z xs) (cons z (take (- x 1) xs))))))))
(define-fun
  (par (a)
    (sort2
       ((x a) (y a)) (list a)
       (ite
         (<= x y) (cons x (cons y (as nil (list a))))
         (cons y (cons x (as nil (list a))))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y l) (+ 1 (length l)))))))
(define-fun-rec
  (par (a)
    (insert2
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (cons x (as nil (list a))))
         (case (cons z xs)
           (ite (<= x z) (cons x y) (cons z (insert2 x xs))))))))
(define-fun-rec
  (par (a)
    (isort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (insert2 y (isort xs)))))))
(define-fun-rec
  (par (a)
    (drop
       ((x Int) (y (list a))) (list a)
       (ite
         (<= x 0) y
         (match y
           (case nil (as nil (list a)))
           (case (cons z xs1) (drop (- x 1) xs1)))))))
(define-fun
  (par (a)
    (splitAt
       ((x Int) (y (list a))) (pair (list a) (list a))
       (pair2 (take x y) (drop x y)))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (reverse
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (++ (reverse xs) (cons y (as nil (list a)))))))))
(define-funs-rec
  ((stooge1sort2 ((x (list Int))) (list Int))
   (stoogesort ((x (list Int))) (list Int))
   (stooge1sort1 ((x (list Int))) (list Int)))
  ((match (splitAt (div (length x) 3) (reverse x))
     (case (pair2 ys2 zs2) (++ (stoogesort zs2) (reverse ys2))))
   (match x
     (case nil (as nil (list Int)))
     (case (cons y z)
       (match z
         (case nil (cons y (as nil (list Int))))
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (stooge1sort2 (stooge1sort1 (stooge1sort2 x)))))))))
   (match (splitAt (div (length x) 3) x)
     (case (pair2 ys2 zs1) (++ ys2 (stoogesort zs1))))))
(assert-not (forall ((x (list Int))) (= (stoogesort x) (isort x))))
(check-sat)
