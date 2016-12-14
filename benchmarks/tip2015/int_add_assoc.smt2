; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Integer (P (proj1-P Nat)) (N (proj1-N Nat)))))
(define-fun-rec
  x-
    ((x Nat) (y Nat)) Integer
    (let
      ((fail
          (match y
            (case Z (P x))
            (case (S z)
              (match x
                (case Z (N y))
                (case (S x2) (x- x2 z)))))))
      (match x
        (case Z
          (match y
            (case Z (P Z))
            (case (S x4) fail)))
        (case (S x3) fail))))
(define-fun pred ((x Nat)) Nat (match x (case (S y) y)))
(define-fun-rec
  plus2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus2 z y)))))
(define-fun
  plus
    ((x Integer) (y Integer)) Integer
    (match x
      (case (P m)
        (match y
          (case (P n) (P (plus2 m n)))
          (case (N o) (x- m (plus2 (S Z) o)))))
      (case (N m2)
        (match y
          (case (P n2) (x- n2 (plus2 (S Z) m2)))
          (case (N n3) (N (plus2 (plus2 (S Z) m2) n3)))))))
(assert-not
  (forall ((x Integer) (y Integer) (z Integer))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(check-sat)
