(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
(define-fun-rec
  zdeleteAll
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z xs)
        (ite (= x z) (zdeleteAll x xs) (cons z (zdeleteAll x xs))))))
(define-fun-rec
  znub
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y xs) (cons y (zdeleteAll y (znub xs))))))
(define-fun-rec
  zcount
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (zcount x xs)) (zcount x xs)))))
(assert-not
  (forall ((x Int) (xs (list Int)))
    (=> (zelem x xs) (= (zcount x (znub xs)) (S Z)))))
(check-sat)
