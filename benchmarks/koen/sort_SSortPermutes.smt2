; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((ssort_minimum ((x int) (y (list int))) int))
  ((match y
     (case nil x)
     (case (cons z ys)
       (ite (<= z x) (ssort_minimum z ys) (ssort_minimum x ys))))))
(define-funs-rec
  ((delete ((x int) (y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((ssort ((x (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons y ys)
       (cons (ssort_minimum y ys)
         (ssort (delete (ssort_minimum y ys) x)))))))
(define-funs-rec
  ((count ((x int) (y (list int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
(assert-not
  (forall ((x int) (y (list int)))
    (= (count x (ssort y)) (count x y))))
(check-sat)
