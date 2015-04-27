; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
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
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Zero y)
     (case (Succ n) (Succ (plus n y))))))
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
     (case (Succ n) (plus y (mult n y))))))
(define-funs-rec
  ((absVal ((x Z)) Nat))
  ((match x
     (case (P n) n)
     (case (N m) (Succ m)))))
(define-funs-rec
  ((times ((x Z) (y Z)) Z))
  ((toInteger (timesSign (sign x) (sign y))
     (mult (absVal x) (absVal y)))))
(assert-not (forall ((x Z) (y Z)) (= (times x y) (times y x))))
(check-sat)
