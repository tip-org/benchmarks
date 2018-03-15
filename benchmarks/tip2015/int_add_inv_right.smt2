; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(declare-datatypes ()
  ((Integer :source Integers.Integer
     (P :source Integers.P (proj1-P Nat))
     (N :source Integers.N (proj1-N Nat)))))
(define-fun zero2 :source Integers.zero () Integer (P zero))
(define-fun-rec
  plus :definition :source |+|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun
  neg :source Integers.neg
    ((x Integer)) Integer
    (match x
      (case (P y)
        (match y
          (case zero (P zero))
          (case (succ z) (N z))))
      (case (N n) (P (plus (succ zero) n)))))
(define-fun-rec
  |-2| :source Integers.-
    ((x Nat) (y Nat)) Integer
    (let
      ((fail
          (match y
            (case zero (P x))
            (case (succ z)
              (match x
                (case zero (N y))
                (case (succ x2) (|-2| x2 z)))))))
      (match x
        (case zero
          (match y
            (case zero (P zero))
            (case (succ x4) fail)))
        (case (succ x3) fail))))
(define-fun
  plus2 :source Integers.plus
    ((x Integer) (y Integer)) Integer
    (match x
      (case (P m)
        (match y
          (case (P n) (P (plus m n)))
          (case (N o) (|-2| m (plus (succ zero) o)))))
      (case (N m2)
        (match y
          (case (P n2) (|-2| n2 (plus (succ zero) m2)))
          (case (N n3) (N (plus (plus (succ zero) m2) n3)))))))
(prove
  :source Integers.prop_add_inv_right
  (forall ((x Integer)) (= (plus2 x (neg x)) zero2)))
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
