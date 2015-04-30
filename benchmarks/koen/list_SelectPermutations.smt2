(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(define-funs-rec
  ((par (a)
     (select2
        ((x a) (y (list (Pair2 a (list a))))) (list (Pair2 a (list a))))))
  ((match y
     (case nil y)
     (case (cons z x2)
       (match z
         (case (Pair y2 ys)
           (cons (Pair y2 (cons x ys)) (select2 x x2))))))))
(define-funs-rec
  ((par (a) (select ((x (list a))) (list (Pair2 a (list a))))))
  ((match x
     (case nil (as nil (list (Pair2 a (list a)))))
     (case (cons y xs) (cons (Pair y xs) (select2 y (select xs)))))))
(define-funs-rec
  ((prop_SelectPermutations
      ((x (list (Pair2 int (list int))))) (list (list int))))
  ((match x
     (case nil (as nil (list (list int))))
     (case (cons y z)
       (match y
         (case (Pair y2 ys)
           (cons (cons y2 ys) (prop_SelectPermutations z))))))))
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
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list int)) (y (list int))) bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(define-funs-rec
  ((par (t) (all ((x (=> t bool)) (y (list t))) bool)))
  ((match y
     (case nil true)
     (case (cons z xs) (and2 (@ x z) (all x xs))))))
(assert-not
  (forall ((xs (list int)))
    (all (lambda ((x (list int))) (isPermutation x xs))
      (prop_SelectPermutations (select xs)))))
(check-sat)
