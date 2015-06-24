; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Nat (Zero) (Succ (pred Nat)))))
(declare-datatypes () ((Z (P (P_0 Nat)) (N (N_0 Nat)))))
(define-fun zero () Z (P Zero))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Zero y)
      (case (Succ n) (Succ (plus n y)))))
(define-fun
  neg
    ((x Z)) Z
    (match x
      (case (P y)
        (match y
          (case Zero (P Zero))
          (case (Succ n) (N n))))
      (case (N m) (P (Succ m)))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Z
    (match x
      (case Zero
        (match y
          (case Zero (P Zero))
          (case (Succ n) (N n))))
      (case (Succ m)
        (match y
          (case Zero (P x))
          (case (Succ o) (minus m o))))))
(define-fun
  plus2
    ((x Z) (y Z)) Z
    (match x
      (case (P m)
        (match y
          (case (P n) (P (plus m n)))
          (case (N o) (minus m (Succ o)))))
      (case (N m2)
        (match y
          (case (P n2) (minus n2 (Succ m2)))
          (case (N n3) (N (Succ (plus m2 n3))))))))
(assert-not (forall ((x Z)) (= (plus2 (neg x) x) zero)))
(check-sat)
