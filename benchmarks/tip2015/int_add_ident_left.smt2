; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Nat (Zero) (Succ (pred Nat)))))
(declare-datatypes () ((Z (P (P_0 Nat)) (N (N_0 Nat)))))
(define-funs-rec ((zero () Z)) ((P Zero)))
(define-funs-rec
  ((plus2 ((x Nat) (y Nat)) Nat))
  ((match x
     (case Zero y)
     (case (Succ n) (Succ (plus2 n y))))))
(define-funs-rec
  ((minus ((x Nat) (y Nat)) Z))
  ((match x
     (case Zero
       (match y
         (case Zero (P y))
         (case (Succ n) (N n))))
     (case (Succ m)
       (match y
         (case Zero (P x))
         (case (Succ o) (minus m o)))))))
(define-funs-rec
  ((plus ((x Z) (y Z)) Z))
  ((match x
     (case (P m)
       (match y
         (case (P n) (P (plus2 m n)))
         (case (N o) (minus m (Succ o)))))
     (case (N m2)
       (match y
         (case (P n2) (minus n2 (Succ m2)))
         (case (N n3) (N (Succ (plus2 m2 n3)))))))))
(assert-not (forall ((x Z)) (= x (plus zero x))))
(check-sat)
