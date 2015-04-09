; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((min2
      ((x Nat) (x2 Nat)) Nat
      (match x
        (case Z x)
        (case
          (S x3)
          (match x2
            (case Z x2)
            (case (S y) (S (min2 x3 y)))))))))
(define-funs-rec
  ((le
      ((x6 Nat) (x7 Nat)) bool
      (match x6
        (case Z true)
        (case
          (S ipv2)
          (match x7
            (case Z false)
            (case (S ipv3) (le ipv2 ipv3))))))))
(define-funs-rec
  ((equal
      ((x4 Nat) (x5 Nat)) bool
      (match x4
        (case
          Z
          (match x5
            (case Z true)
            (case (S ipv) false)))
        (case
          (S ds)
          (match x5
            (case Z false)
            (case (S y2) (equal ds y2))))))))
(assert
  (not (forall ((a Nat) (b Nat)) (= (equal (min2 a b) a) (le a b)))))
(check-sat)
