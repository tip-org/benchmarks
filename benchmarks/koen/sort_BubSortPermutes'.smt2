; Bubble sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(define-funs-rec ((or2 ((x bool) (y bool)) bool)) ((ite x true y)))
(define-funs-rec
  ((par (t) (null ((x (list t))) bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((elem ((x int) (y (list int))) bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((delete ((x int) (y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((bubble ((x (list int))) (Pair2 bool (list int))))
  ((match x
     (case nil (Pair false x))
     (case (cons y z)
       (match z
         (case nil (Pair false x))
         (case (cons y2 xs)
           (ite
             (<= y y2)
             (match (bubble z)
               (case (Pair b6 ys5)
                 (ite
                   (<= y y2)
                   (ite
                     (<= y y2)
                     (match (bubble z)
                       (case (Pair b10 ys9) (Pair (or2 (not (<= y y2)) b6) (cons y ys9))))
                     (match (bubble (cons y xs))
                       (case (Pair b9 ys8) (Pair (or2 (not (<= y y2)) b6) (cons y ys8)))))
                   (ite
                     (<= y y2)
                     (match (bubble z)
                       (case (Pair b8 ys7) (Pair (or2 (not (<= y y2)) b6) (cons y2 ys7))))
                     (match (bubble (cons y xs))
                       (case (Pair b7 ys6)
                         (Pair (or2 (not (<= y y2)) b6) (cons y2 ys6))))))))
             (match (bubble (cons y xs))
               (case (Pair c ys)
                 (ite
                   (<= y y2)
                   (ite
                     (<= y y2)
                     (match (bubble z)
                       (case (Pair b5 ys4) (Pair (or2 (not (<= y y2)) c) (cons y ys4))))
                     (match (bubble (cons y xs))
                       (case (Pair b4 ys3) (Pair (or2 (not (<= y y2)) c) (cons y ys3)))))
                   (ite
                     (<= y y2)
                     (match (bubble z)
                       (case (Pair b3 ys2) (Pair (or2 (not (<= y y2)) c) (cons y2 ys2))))
                     (match (bubble (cons y xs))
                       (case (Pair b2 zs)
                         (Pair (or2 (not (<= y y2)) c) (cons y2 zs)))))))))))))))
(define-funs-rec
  ((bubsort ((x (list int))) (list int)))
  ((match (bubble x)
     (case (Pair c ys)
       (ite c (match (bubble x) (case (Pair b2 xs) (bubsort xs))) x)))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list int)) (y (list int))) bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not
  (forall ((x (list int))) (isPermutation (bubsort x) x)))
(check-sat)
