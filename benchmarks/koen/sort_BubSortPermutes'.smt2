; Bubble sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-funs-rec ((or2 ((x Bool) (y Bool)) Bool)) ((ite x true y)))
(define-funs-rec
  ((par (t) (null ((x (list t))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((elem ((x Int) (y (list Int))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((bubble ((x (list Int))) (Pair Bool (list Int))))
  ((match x
     (case nil (Pair2 false x))
     (case (cons y z)
       (match z
         (case nil (Pair2 false x))
         (case (cons y2 xs)
           (ite
             (<= y y2)
             (match (bubble z)
               (case (Pair2 b6 ys5)
                 (ite
                   (<= y y2)
                   (ite
                     (<= y y2)
                     (match (bubble z)
                       (case (Pair2 b10 ys9)
                         (Pair2 (or2 (not (<= y y2)) b6) (cons y ys9))))
                     (match (bubble (cons y xs))
                       (case (Pair2 b9 ys8)
                         (Pair2 (or2 (not (<= y y2)) b6) (cons y ys8)))))
                   (ite
                     (<= y y2)
                     (match (bubble z)
                       (case (Pair2 b8 ys7)
                         (Pair2 (or2 (not (<= y y2)) b6) (cons y2 ys7))))
                     (match (bubble (cons y xs))
                       (case (Pair2 b7 ys6)
                         (Pair2 (or2 (not (<= y y2)) b6) (cons y2 ys6))))))))
             (match (bubble (cons y xs))
               (case (Pair2 c ys)
                 (ite
                   (<= y y2)
                   (ite
                     (<= y y2)
                     (match (bubble z)
                       (case (Pair2 b5 ys4) (Pair2 (or2 (not (<= y y2)) c) (cons y ys4))))
                     (match (bubble (cons y xs))
                       (case (Pair2 b4 ys3)
                         (Pair2 (or2 (not (<= y y2)) c) (cons y ys3)))))
                   (ite
                     (<= y y2)
                     (match (bubble z)
                       (case (Pair2 b3 ys2)
                         (Pair2 (or2 (not (<= y y2)) c) (cons y2 ys2))))
                     (match (bubble (cons y xs))
                       (case (Pair2 b2 zs)
                         (Pair2 (or2 (not (<= y y2)) c) (cons y2 zs)))))))))))))))
(define-funs-rec
  ((bubsort ((x (list Int))) (list Int)))
  ((match (bubble x)
     (case (Pair2 c ys)
       (ite c (match (bubble x) (case (Pair2 b2 xs) (bubsort xs))) x)))))
(define-funs-rec
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list Int)) (y (list Int))) Bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not
  (forall ((x (list Int))) (isPermutation (bubsort x) x)))
(check-sat)
