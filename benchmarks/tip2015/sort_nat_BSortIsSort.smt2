; Bitonic sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun
  (par (a)
    (sort2
       ((x a) (y a)) (list a)
       (ite
         (<= x y) (cons x (cons y (as nil (list a))))
         (cons y (cons x (as nil (list a))))))))
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
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (as nil (list a)))
     (case (cons y xs) (evens xs)))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (pairs
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z x2)
           (match y
             (case nil x)
             (case (cons x3 x4) (++ (sort2 z x3) (pairs x2 x4)))))))))
(define-fun
  (par (a)
    (stitch
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (pairs xs y)))))))
(define-fun-rec
  (par (a)
    (bmerge
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons z x2)
           (match y
             (case nil x)
             (case (cons x3 x4)
               (let
                 ((fail
                     (stitch (bmerge (evens x) (evens y)) (bmerge (odds x) (odds y)))))
                 (match x2
                   (case nil
                     (match x4
                       (case nil (sort2 z x3))
                       (case (cons x5 x6) fail)))
                   (case (cons x7 x8) fail))))))))))
(define-fun-rec
  (par (a)
    (bsort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y z)
           (match z
             (case nil (cons y (as nil (list a))))
             (case (cons x2 x3)
               (bmerge (bsort (evens x)) (bsort (odds x))))))))))
(assert-not (forall ((x (list Nat))) (= (bsort x) (isort x))))
(check-sat)
