; Weird functions over natural numbers
;
; Property about a trinary multiplication function, defined in terms of an
; trinary addition function
; mul3 x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  plus :definition :source |+|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun-rec
  times :definition :source |*|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z) (plus y (times z y)))))
(define-fun-rec
  add3 :source WeirdInt.add3
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case zero
        (match y
          (case zero z)
          (case (succ x3) (plus (succ zero) (add3 zero x3 z)))))
      (case (succ x2) (plus (succ zero) (add3 x2 y z)))))
(define-fun-rec
  mul3 :source WeirdInt.mul3
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case zero zero)
      (case (succ x2)
        (match y
          (case zero zero)
          (case (succ x3)
            (match z
              (case zero zero)
              (case (succ x4)
                (let
                  ((fail
                      (plus (succ zero)
                        (add3 (mul3 x2 x3 x4)
                          (add3 (mul3 (succ zero) x3 x4)
                            (mul3 x2 (succ zero) x4) (mul3 x2 x3 (succ zero)))
                          (add3 x2 x3 x4)))))
                  (ite
                    (= x2 zero)
                    (ite (= x3 zero) (ite (= x4 zero) (succ zero) fail) fail)
                    fail)))))))))
(prove
  :source WeirdInt.prop_mul3_spec
  (forall ((x Nat) (y Nat) (z Nat))
    (= (mul3 x y z) (times (times x y) z))))
(assert
  :axiom |associativity of *|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (times y z)) (times (times x y) z))))
(assert
  :axiom |associativity of +|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert
  :axiom |commutativity of *|
  (forall ((x Nat) (y Nat)) (= (times x y) (times y x))))
(assert
  :axiom |commutativity of +|
  (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert
  :axiom distributivity
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (plus y z)) (plus (times x y) (times x z)))))
(assert
  :axiom distributivity
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times (plus x y) z) (plus (times x z) (times y z)))))
(assert
  :axiom |identity for *|
  (forall ((x Nat)) (= (times x (succ zero)) x)))
(assert
  :axiom |identity for *|
  (forall ((x Nat)) (= (times (succ zero) x) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus x zero) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus zero x) x)))
(assert
  :axiom |zero for *|
  (forall ((x Nat)) (= (times x zero) zero)))
(assert
  :axiom |zero for *|
  (forall ((x Nat)) (= (times zero x) zero)))
