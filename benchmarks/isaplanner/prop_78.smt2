; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
;
; This property is the same as prod #14
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  <=2
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (<=2 z x2))))))
(define-fun-rec
  insort
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (cons x (as nil (list Nat))))
      (case (cons z xs)
        (ite (<=2 x z) (cons x y) (cons z (insort x xs))))))
(define-fun-rec
  sort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons y xs) (insort y (sort xs)))))
(define-fun && ((x Bool) (y Bool)) Bool (ite x y false))
(define-fun-rec
  sorted
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 ys) (&& (<=2 y y2) (sorted z)))))))
(assert-not (forall ((xs (list Nat))) (sorted (sort xs))))
(check-sat)
