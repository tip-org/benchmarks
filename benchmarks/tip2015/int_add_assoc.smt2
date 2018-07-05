; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(declare-datatypes ()
  ((Integer (P (proj1-P Nat)) (N (proj1-N Nat)))))
(define-fun-rec
  plus2
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus2 z y)))))
(define-fun-rec
  |-2|
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
  plus
    ((x Integer) (y Integer)) Integer
    (match x
      (case (P m)
        (match y
          (case (P n) (P (plus2 m n)))
          (case (N o) (|-2| m (plus2 (succ zero) o)))))
      (case (N m2)
        (match y
          (case (P n2) (|-2| n2 (plus2 (succ zero) m2)))
          (case (N n3) (N (plus2 (plus2 (succ zero) m2) n3)))))))
(prove
  (forall ((x Integer) (y Integer) (z Integer))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus2 x (plus2 y z)) (plus2 (plus2 x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus2 x y) (plus2 y x))))
(assert (forall ((x Nat)) (= (plus2 x zero) x)))
(assert (forall ((x Nat)) (= (plus2 zero x) x)))
