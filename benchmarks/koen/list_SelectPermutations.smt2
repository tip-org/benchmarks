(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-funs-rec
  ((par (a)
     (select2
        ((x a) (y (list (Pair a (list a))))) (list (Pair a (list a))))))
  ((match y
     (case nil (as nil (list (Pair a (list a)))))
     (case (cons z x2)
       (match z
         (case (Pair2 y2 ys)
           (cons (Pair2 y2 (cons x ys)) (select2 x x2))))))))
(define-funs-rec
  ((par (a) (select ((x (list a))) (list (Pair a (list a))))))
  ((match x
     (case nil (as nil (list (Pair a (list a)))))
     (case (cons y xs) (cons (Pair2 y xs) (select2 y (select xs)))))))
(define-funs-rec
  ((prop_SelectPermutations
      ((x (list (Pair Int (list Int))))) (list (list Int))))
  ((match x
     (case nil (as nil (list (list Int))))
     (case (cons y z)
       (match y
         (case (Pair2 y2 ys)
           (cons (cons y2 ys) (prop_SelectPermutations z))))))))
(define-funs-rec
  ((par (t) (null ((x (list t))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((elem ((x Int) (y (list Int))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or (= x z) (elem x ys))))))
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (as nil (list Int)))
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((isPermutation ((x (list Int)) (y (list Int))) Bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and (elem z y) (isPermutation xs (delete z y)))))))
(define-funs-rec
  ((par (t) (all ((x (=> t Bool)) (y (list t))) Bool)))
  ((match y
     (case nil true)
     (case (cons z xs) (and (@ x z) (all x xs))))))
(assert-not
  (forall ((xs (list Int)))
    (all (lambda ((x (list Int))) (isPermutation x xs))
      (prop_SelectPermutations (select xs)))))
(check-sat)
