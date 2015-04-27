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
  ((qfac ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (qfac z (mult x y))))))
(define-funs-rec
  ((fac ((x Nat)) Nat))
  ((match x
     (case Z (S x))
     (case (S y) (mult x (fac y))))))
(assert-not (forall ((x Nat)) (= (fac x) (qfac x one))))
(check-sat)
