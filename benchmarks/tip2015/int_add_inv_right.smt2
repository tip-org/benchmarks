; Integers implemented using natural numbers
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes () ((Z2 (P (P_ Nat)) (N (N_ Nat)))))
(define-funs-rec ((zero () Z2 (P Z))))
(define-funs-rec
  ((plus
      ((x Nat) (x2 Nat)) Nat
      (match x
        (case Z x2)
        (case (S n) (S (plus n x2)))))))
(define-funs-rec
  ((neg
      ((x5 Z2)) Z2
      (match x5
        (case
          (P ds)
          (match ds
            (case Z x5)
            (case (S n6) (N n6))))
        (case (N n7) (P (S n7)))))))
(define-funs-rec
  ((minus
      ((x6 Nat) (x7 Nat)) Z2
      (match x6
        (case
          Z
          (match x7
            (case Z (P x7))
            (case (S n8) (N n8))))
        (case
          (S m3)
          (match x7
            (case Z (P x6))
            (case (S n9) (minus m3 n9))))))))
(define-funs-rec
  ((plus2
      ((x3 Z2) (x4 Z2)) Z2
      (match x3
        (case
          (P m)
          (match x4
            (case (P n2) (P (plus m n2)))
            (case (N n3) (minus m (S n3)))))
        (case
          (N m2)
          (match x4
            (case (P n4) (minus n4 (S m2)))
            (case (N n5) (N (S (plus m2 n5))))))))))
(assert (not (forall ((x8 Z2)) (= (plus2 x8 (neg x8)) zero))))
(check-sat)
