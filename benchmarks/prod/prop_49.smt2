; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun x ((y Bool) (z Bool)) Bool (ite y true z))
(define-fun-rec
  ==
    ((y Nat) (z Nat)) Bool
    (match y
      (case Z
        (match z
          (case Z true)
          (case (S x2) false)))
      (case (S x3)
        (match z
          (case Z false)
          (case (S y2) (== x3 y2))))))
(define-fun-rec
  elem
    ((y Nat) (z (list Nat))) Bool
    (match z
      (case nil false)
      (case (cons x2 xs) (x (== y x2) (elem y xs)))))
(define-fun-rec
  <=2
    ((y Nat) (z Nat)) Bool
    (match y
      (case Z true)
      (case (S x2)
        (match z
          (case Z false)
          (case (S x3) (<=2 x2 x3))))))
(define-fun-rec
  insert2
    ((y Nat) (z (list Nat))) (list Nat)
    (match z
      (case nil (cons y (as nil (list Nat))))
      (case (cons x2 xs)
        (ite (<=2 y x2) (cons y z) (cons x2 (insert2 y xs))))))
(define-fun-rec
  isort
    ((y (list Nat))) (list Nat)
    (match y
      (case nil (as nil (list Nat)))
      (case (cons z xs) (insert2 z (isort xs)))))
(assert-not
  (forall ((y Nat) (z (list Nat)))
    (=> (elem y (isort z)) (elem y z))))
(check-sat)
