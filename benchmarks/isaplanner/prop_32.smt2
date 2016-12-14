; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  min2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z Z)
          (case (S y1) (S (min2 z y1)))))))
(assert-not (forall ((a Nat) (b Nat)) (= (min2 a b) (min2 b a))))
(check-sat)
