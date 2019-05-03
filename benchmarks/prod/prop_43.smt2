; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun
  barbar
  ((x Bool) (y Bool)) Bool (ite x true y))
(define-fun-rec
  ==
  ((x Nat) (y Nat)) Bool
  (match x
    ((Z
      (match y
        ((Z true)
         ((S z) false))))
     ((S x2)
      (match y
        ((Z false)
         ((S y2) (== x2 y2))))))))
(define-fun-rec
  elem
  ((x Nat) (y (list Nat))) Bool
  (match y
    ((nil false)
     ((cons z xs) (barbar (== x z) (elem x xs))))))
(define-fun-rec
  union
  ((x (list Nat)) (y (list Nat))) (list Nat)
  (match x
    ((nil y)
     ((cons z xs)
      (ite (elem z y) (union xs y) (cons z (union xs y)))))))
(prove
  (forall ((x Nat) (y (list Nat)) (z (list Nat)))
    (=> (elem x y) (elem x (union z y)))))
