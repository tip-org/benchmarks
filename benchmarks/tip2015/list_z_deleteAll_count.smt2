(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zdeleteAll
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z xs)
        (ite (= x z) (zdeleteAll x xs) (cons z (zdeleteAll x xs))))))
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
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(assert-not
  (forall ((x Int) (xs (list Int)))
    (=> (= (zdeleteAll x xs) (zdelete x xs))
      (le (zcount x xs) (S Z)))))
(check-sat)
