; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  x-
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (x- z x2))))))
(assert-not
  (forall ((m Nat) (n Nat) (k Nat))
    (= (x- (x- (S m) n) (S k)) (x- (x- m n) k))))
(check-sat)
