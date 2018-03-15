; Weird functions over natural numbers
;
; Property about a trinary multiplication function, defined in terms of an
; accumulative trinary addition function
; mul3acc x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  plus :definition :source |+|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun-rec
  add3acc :source WeirdInt.add3acc
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case zero
        (match y
          (case zero z)
          (case (succ x3) (add3acc zero x3 (succ z)))))
      (case (succ x2) (add3acc x2 (succ y) z))))
(define-fun-rec
  mul3acc :source WeirdInt.mul3acc
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
                        (add3acc (mul3acc x2 x3 x4)
                          (add3acc (mul3acc (succ zero) x3 x4)
                            (mul3acc x2 (succ zero) x4) (mul3acc x2 x3 (succ zero)))
                          (add3acc x y z)))))
                  (ite
                    (= x2 zero)
                    (ite (= x3 zero) (ite (= x4 zero) (succ zero) fail) fail)
                    fail)))))))))
(prove
  :source WeirdInt.prop_mul3acc_comm13
  (forall ((x Nat) (y Nat) (z Nat))
    (= (mul3acc x y z) (mul3acc z y x))))
(assert
  :axiom |associativity of +|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert
  :axiom |commutativity of +|
  (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus x zero) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus zero x) x)))
