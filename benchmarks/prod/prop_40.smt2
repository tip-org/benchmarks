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
  union2
    ((y (list Nat)) (z (list Nat))) (list Nat)
    (match y
      (case nil z)
      (case (cons x2 xs)
        (ite (elem x2 z) (union2 xs z) (cons x2 (union2 xs z))))))
(define-fun && ((y Bool) (z Bool)) Bool (ite y z false))
(define-fun-rec
  subset2
    ((y (list Nat)) (z (list Nat))) Bool
    (match y
      (case nil true)
      (case (cons x2 xs) (&& (elem x2 z) (subset2 xs z)))))
(assert-not
  (forall ((y (list Nat)) (z (list Nat)))
    (=> (subset2 y z) (= (union2 y z) z))))
(check-sat)
