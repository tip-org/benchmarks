; Stooge sort defined using reverse and thirds on natural numbers
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  third
  ((x Int)) Int
  (ite
    (= x 2) 0 (ite (= x 1) 0 (ite (= x 0) 0 (+ 1 (third (- x 3)))))))
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
  count
  (par (a) (((x a) (y (list a))) Int))
  (match y
    ((nil 0)
     ((cons z ys) (ite (= x z) (+ 1 (count x ys)) (count x ys))))))
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
  ((nstooge1sort2
    ((x (list Int))) (list Int))
   (nstoogesort
    ((x (list Int))) (list Int))
   (nstooge1sort1
    ((x (list Int))) (list Int)))
  ((match (splitAt (third (length x)) (reverse x))
     (((pair2 ys1 zs1) (++ (nstoogesort zs1) (reverse ys1)))))
   (match x
     ((nil (_ nil Int))
      ((cons y z)
       (match z
         ((nil (cons y (_ nil Int)))
          ((cons y2 x2)
           (match x2
             ((nil (sort2 y y2))
              ((cons x3 x4)
               (nstooge1sort2 (nstooge1sort1 (nstooge1sort2 x))))))))))))
   (match (splitAt (third (length x)) x)
     (((pair2 ys1 zs) (++ ys1 (nstoogesort zs)))))))
(prove
  (forall ((x Int) (xs (list Int)))
    (= (count x (nstoogesort xs)) (count x xs))))
