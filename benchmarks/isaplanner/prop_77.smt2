; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x Nat) (y Nat)) Bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (le z x2)))))))
(define-funs-rec
  ((sorted ((x (list Nat))) Bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 ys) (ite (le y y2) (sorted z) false)))))))
(define-funs-rec
  ((insort ((x Nat) (y (list Nat))) (list Nat)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs)
       (ite (le x z) (cons x y) (cons z (insort x xs)))))))
(assert-not
  (forall ((x Nat) (xs (list Nat)))
    (=> (sorted xs) (sorted (insort x xs)))))
(check-sat)
