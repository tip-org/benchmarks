; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((max2
      ((x Nat) (x2 Nat)) Nat
      (match x
        (case Z x2)
        (case
          (S ipv)
          (match x2
            (case Z x)
            (case (S ipv2) (S (max2 ipv ipv2)))))))))
(define-funs-rec
  ((le
      ((x5 Nat) (x6 Nat)) bool
      (match x5
        (case Z true)
        (case
          (S ipv4)
          (match x6
            (case Z false)
            (case (S ipv5) (le ipv4 ipv5))))))))
(define-funs-rec
  ((equal
      ((x3 Nat) (x4 Nat)) bool
      (match x3
        (case
          Z
          (match x4
            (case Z true)
            (case (S ipv3) false)))
        (case
          (S ds)
          (match x4
            (case Z false)
            (case (S y) (equal ds y))))))))
(assert
  (not (forall ((a Nat) (b Nat)) (= (equal (max2 a b) a) (le b a)))))
(check-sat)
