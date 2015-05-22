; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((min2 ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z Z)
     (case (S z)
       (match y
         (case Z Z)
         (case (S y1) (S (min2 z y1))))))))
(define-funs-rec
  ((le ((x Nat) (y Nat)) Bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (le z x2)))))))
(define-funs-rec
  ((equal ((x Nat) (y Nat)) Bool))
  ((match x
     (case Z
       (match y
         (case Z true)
         (case (S z) false)))
     (case (S x2)
       (match y
         (case Z false)
         (case (S y2) (equal x2 y2)))))))
(assert-not
  (forall ((a Nat) (b Nat)) (= (equal (min2 a b) b) (le b a))))
(check-sat)
