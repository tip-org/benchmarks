; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  half
  ((x Nat)) Nat
  (match x
    ((Z Z)
     ((S y)
      (match y
        ((Z Z)
         ((S z) (S (half z)))))))))
(define-fun-rec
  +2
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z y)
     ((S z) (S (+2 z y))))))
(prove (forall ((x Nat)) (= (half (+2 x x)) x)))
