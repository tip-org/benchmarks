; Weird functions over natural numbers
;
; Property about accumulative trinary addition function
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
(prove
  :source WeirdInt.prop_add3acc_spec
  (forall ((x Nat) (y Nat) (z Nat))
    (= (add3acc x y z) (plus x (plus y z)))))
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
