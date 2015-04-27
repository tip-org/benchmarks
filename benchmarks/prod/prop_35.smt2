; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (S (plus z y))))))
(define-funs-rec ((one () Nat)) ((S Z)))
(define-funs-rec
  ((mult ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S z) (plus y (mult z y))))))
(define-funs-rec
  ((qexp ((x Nat) (y Nat) (z Nat)) Nat))
  ((match y
     (case Z z)
     (case (S n) (qexp x n (mult x z))))))
(define-funs-rec
  ((exp ((x Nat) (y Nat)) Nat))
  ((match y
     (case Z (S y))
     (case (S n) (mult x (exp x n))))))
(assert-not
  (forall ((x Nat) (y Nat)) (= (exp x y) (qexp x y one))))
(check-sat)
