; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((ssort_minimum ((x Int) (y (list Int))) Int))
  ((match y
     (case nil x)
     (case (cons z ys)
       (ite (<= z x) (ssort_minimum z ys) (ssort_minimum x ys))))))
(define-funs-rec
  ((delete ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (as nil (list Int)))
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((ssort ((x (list Int))) (list Int)))
  ((match x
     (case nil (as nil (list Int)))
     (case (cons y ys)
       (let (((m Int) (ssort_minimum y ys)))
         (cons m (ssort (delete m x))))))))
(define-funs-rec
  ((count ((x Int) (y (list Int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (count x (ssort y)) (count x y))))
(check-sat)
