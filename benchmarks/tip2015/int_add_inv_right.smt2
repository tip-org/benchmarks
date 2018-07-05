; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(declare-datatypes ()
  ((Integer (P (proj1-P Nat)) (N (proj1-N Nat)))))
(define-fun zero2 () Integer (P zero))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun
  neg
    ((x Integer)) Integer
    (match x
      (case (P y)
        (match y
          (case zero (P zero))
          (case (succ z) (N z))))
      (case (N n) (P (plus (succ zero) n)))))
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
  plus2
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
(prove (forall ((x Integer)) (= (plus2 x (neg x)) zero2)))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
