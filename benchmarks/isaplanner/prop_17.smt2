; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le
      ((x3 Nat) (x4 Nat)) bool
      (match x3
        (case Z true)
        (case
          (S ipv2)
          (match x4
            (case Z false)
            (case (S ipv3) (le ipv2 ipv3))))))))
(define-funs-rec
  ((equal
      ((x Nat) (x2 Nat)) bool
      (match x
        (case
          Z
          (match x2
            (case Z true)
            (case (S ipv) false)))
        (case
          (S ds)
          (match x2
            (case Z false)
            (case (S y) (equal ds y))))))))
(assert (not (forall ((n Nat)) (= (le n Z) (equal n Z)))))
(check-sat)
