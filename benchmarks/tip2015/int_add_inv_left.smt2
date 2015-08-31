; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes () ((Integer (P (P_0 Nat)) (N (N_0 Nat)))))
(define-fun zero () Integer (P Z))
(define-fun-rec
  plus2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus2 n y)))))
(define-fun
  neg
    ((x Integer)) Integer
    (match x
      (case (P y)
        (match y
          (case Z (P Z))
          (case (S n) (N n))))
      (case (N m) (P (S m)))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Integer
    (match x
      (case Z
        (match y
          (case Z (P Z))
          (case (S n) (N n))))
      (case (S m)
        (match y
          (case Z (P x))
          (case (S o) (minus m o))))))
(define-fun
  plus
    ((x Integer) (y Integer)) Integer
    (match x
      (case (P m)
        (match y
          (case (P n) (P (plus2 m n)))
          (case (N o) (minus m (S o)))))
      (case (N m2)
        (match y
          (case (P n2) (minus n2 (S m2)))
          (case (N n3) (N (S (plus2 m2 n3))))))))
(assert-not (forall ((x Integer)) (= (plus (neg x) x) zero)))
(check-sat)
