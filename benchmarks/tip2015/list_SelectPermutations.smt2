(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
(define-fun-rec
  zdelete
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys) (ite (= x z) ys (cons z (zdelete x ys))))))
(define-fun-rec
  (par (a)
    (select3
       ((x a) (y (list (Pair a (list a))))) (list (Pair a (list a)))
       (match y
         (case nil (as nil (list (Pair a (list a)))))
         (case (cons z x2)
           (match z
             (case (Pair2 y2 ys)
               (cons (Pair2 y2 (cons x ys)) (select3 x x2)))))))))
(define-fun-rec
  (par (a)
    (select2
       ((x (list a))) (list (Pair a (list a)))
       (match x
         (case nil (as nil (list (Pair a (list a)))))
         (case (cons y xs) (cons (Pair2 y xs) (select3 y (select2 xs))))))))
(define-fun-rec
  prop_SelectPermutations
    ((x (list (Pair Int (list Int))))) (list (list Int))
    (match x
      (case nil (as nil (list (list Int))))
      (case (cons y z)
        (match y
          (case (Pair2 y2 ys)
            (cons (cons y2 ys) (prop_SelectPermutations z)))))))
(define-fun
  (par (a)
    (null
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  zisPermutation
    ((x (list Int)) (y (list Int))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (and (zelem z y) (zisPermutation xs (zdelete z y))))))
(define-fun-rec
  (par (a)
    (all
       ((x (=> a Bool)) (y (list a))) Bool
       (match y
         (case nil true)
         (case (cons z xs) (and (@ x z) (all x xs)))))))
(assert-not
  (forall ((xs (list Int)))
    (all (lambda ((x (list Int))) (zisPermutation x xs))
      (prop_SelectPermutations (select2 xs)))))
(check-sat)
