(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun-rec
  elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (equal x z) (elem x ys)))))
(define-fun-rec
  deleteAll
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (as nil (list Nat)))
      (case (cons z xs)
        (ite (equal x z) (deleteAll x xs) (cons z (deleteAll x xs))))))
(define-fun-rec
  nub
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons y xs) (cons y (deleteAll y (nub xs))))))
(define-fun-rec
  count
    ((x Nat) (y (list Nat))) Nat
    (match y
      (case nil Z)
      (case (cons z ys)
        (ite (equal x z) (S (count x ys)) (count x ys)))))
(assert-not
  (forall ((x Nat) (xs (list Nat)))
    (=> (elem x xs) (= (count x (nub xs)) (S Z)))))
(check-sat)
