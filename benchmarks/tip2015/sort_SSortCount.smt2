; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zdelete
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys) (ite (= x z) ys (cons z (zdelete x ys))))))
(define-fun-rec
  zcount
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (zcount x xs)) (zcount x xs)))))
(define-fun-rec
  ssort_minimum
    ((x Int) (y (list Int))) Int
    (match y
      (case nil x)
      (case (cons z ys)
        (ite (<= z x) (ssort_minimum z ys) (ssort_minimum x ys)))))
(define-fun-rec
  ssort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y ys)
        (let ((m (ssort_minimum y ys))) (cons m (ssort (zdelete m x)))))))
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (zcount x (ssort y)) (zcount x y))))
(check-sat)
