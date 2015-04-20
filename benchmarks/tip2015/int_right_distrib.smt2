; Integers implemented using natural numbers (from Agda standard library)
(declare-datatypes () ((Sign (Pos) (Neg))))
(declare-datatypes () ((Nat (Zero) (Succ (pred Nat)))))
(declare-datatypes () ((Z (P (P_0 Nat)) (N (N_0 Nat)))))
(define-funs-rec
  ((toInteger ((x Sign) (y Nat)) Z))
  ((match x
     (case Pos (P y))
     (case Neg
       (match y
         (case Zero (P y))
         (case (Succ m) (N m)))))))
(define-funs-rec
  ((sign ((x Z)) Sign))
  ((match x
     (case (P y) Pos)
     (case (N z) Neg))))
(define-funs-rec
  ((plus2 ((x Nat) (y Nat)) Nat))
  ((match x
     (case Zero y)
     (case (Succ n) (Succ (plus2 n y))))))
(define-funs-rec
  ((opposite ((x Sign)) Sign))
  ((match x
     (case Pos Neg)
     (case Neg Pos))))
(define-funs-rec
  ((timesSign ((x Sign) (y Sign)) Sign))
  ((match x
     (case Pos y)
     (case Neg (opposite y)))))
(define-funs-rec
  ((mult ((x Nat) (y Nat)) Nat))
  ((match x
     (case Zero x)
     (case (Succ n) (plus2 y (mult n y))))))
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
(define-funs-rec
  ((absVal ((x Z)) Nat))
  ((match x
     (case (P n) n)
     (case (N m) (Succ m)))))
(define-funs-rec
  ((times ((x Z) (y Z)) Z))
  ((toInteger (timesSign (sign x) (sign y))
     (mult (absVal x) (absVal y)))))
(assert-not
  (forall ((x Z) (y Z) (z Z))
    (= (times (plus x y) z) (plus (times x z) (times y z)))))
(check-sat)
