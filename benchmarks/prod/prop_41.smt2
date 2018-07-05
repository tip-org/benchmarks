; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun |\|\|| ((x Bool) (y Bool)) Bool (ite x true y))
(define-fun-rec
  ==
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (== x2 y2))))))
(define-fun-rec
  elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z xs) (|\|\|| (== x z) (elem x xs)))))
(define-fun-rec
  intersect
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons z xs)
        (ite (elem z y) (cons z (intersect xs y)) (intersect xs y)))))
(define-fun && ((x Bool) (y Bool)) Bool (ite x y false))
(define-fun-rec
  subset
    ((x (list Nat)) (y (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons z xs) (&& (elem z y) (subset xs y)))))
(prove
  (forall ((x (list Nat)) (y (list Nat)))
    (=> (subset x y) (= (intersect x y) x))))
