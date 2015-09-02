; Regular expressions using Brzozowski derivatives (see the step function)
; This version does not use smart constructors.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes ()
  ((R (Nil)
     (Eps) (Atom (Atom_0 A)) (Plus (Plus_0 R) (Plus_1 R))
     (And (And_0 R) (And_1 R)) (Seq (Seq_0 R) (Seq_1 R))
     (Star (Star_0 R)))))
(define-fun
  minus1
    ((x Nat)) Nat
    (match x
      (case Z Z)
      (case (S y) y)))
(define-fun-rec
  min2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z Z)
          (case (S x2) (S (min2 z x2)))))))
(define-fun-rec
  max2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (S (max2 z x2)))))))
(define-fun
  isZero2
    ((x Nat)) Bool
    (match x
      (case Z true)
      (case (S y) false)))
(define-fun
  eqA
    ((x A) (y A)) Bool
    (match x
      (case X
        (match y
          (case X true)
          (case Y false)))
      (case Y
        (match y
          (case X false)
          (case Y true)))))
(define-fun-rec
  eps
    ((x R)) Bool
    (match x
      (case default false)
      (case Eps true)
      (case (Plus q q2) (or (eps q) (eps q2)))
      (case (And p2 q3) (and (eps p2) (eps q3)))
      (case (Seq p3 q4) (and (eps p3) (eps q4)))
      (case (Star y) true)))
(define-fun epsR ((x R)) R (ite (eps x) Eps Nil))
(define-fun-rec
  step
    ((x R) (y A)) R
    (match x
      (case default Nil)
      (case (Atom a) (ite (eqA a y) Eps Nil))
      (case (Plus q q2) (Plus (step q y) (step q2 y)))
      (case (And p2 q3) (And (step p2 y) (step q3 y)))
      (case (Seq p3 q4)
        (Plus (Seq (step p3 y) q4) (Seq (epsR p3) (step q4 y))))
      (case (Star p4) (Seq (step p4 y) x))))
(define-fun-rec
  recognise
    ((x R) (y (list A))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (recognise (step x z) xs))))
(define-fun cond ((x Bool)) R (ite x Eps Nil))
(define-fun-rec
  rep
    ((x R) (y Nat) (z Nat)) R
    (match z
      (case Z
        (match y
          (case Z Eps)
          (case (S x2) Nil)))
      (case (S j)
        (Seq (Plus (cond (isZero2 y)) x) (rep x (minus1 y) j)))))
(assert-not
  (forall ((q R) (i Nat) (i2 Nat) (j Nat) (j2 Nat) (s (list A)))
    (=> (not (eps q))
      (= (recognise (And (rep q i j) (rep q i2 j2)) s)
        (recognise (rep q (max2 i i2) (min2 j j2)) s)))))
(check-sat)
