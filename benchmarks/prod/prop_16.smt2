; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  even
    ((x Nat)) Bool
    (match x
      (case Z true)
      (case (S y)
        (match y
          (case Z false)
          (case (S z) (even z))))))
(define-fun-rec
  +2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (+2 z y)))))
(assert-not (forall ((x Nat)) (even (+2 x x))))
(check-sat)
