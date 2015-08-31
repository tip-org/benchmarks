; Insertion sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zcount
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (zcount x xs)) (zcount x xs)))))
(define-fun-rec
  insert2
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (cons x (as nil (list Int))))
      (case (cons z xs)
        (ite (<= x z) (cons x y) (cons z (insert2 x xs))))))
(define-fun-rec
  isort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y xs) (insert2 y (isort xs)))))
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (zcount x (isort y)) (zcount x y))))
(check-sat)
