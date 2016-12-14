; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  half
    ((x Nat)) Nat
    (match x
      (case Z Z)
      (case (S y)
        (match y
          (case Z Z)
          (case (S z) (S (half z)))))))
(define-fun-rec
  +2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (+2 z y)))))
(assert-not
  (forall ((x Nat) (y Nat)) (= (half (+2 x y)) (half (+2 y x)))))
(check-sat)
