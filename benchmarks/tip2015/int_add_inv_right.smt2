; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Integer :source Integers.Integer
     (P :source Integers.P (proj1-P Nat))
     (N :source Integers.N (proj1-N Nat)))))
(define-fun zero :source Integers.zero () Integer (P Z))
(define-fun
  pred :source Integers.pred ((x Nat)) Nat (match x (case (S y) y)))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun
  neg :source Integers.neg
    ((x Integer)) Integer
    (match x
      (case (P y)
        (match y
          (case Z (P Z))
          (case (S z) (N z))))
      (case (N n) (P (plus (S Z) n)))))
(define-fun-rec
  |-2| :source Integers.-
    ((x Nat) (y Nat)) Integer
    (let
      ((fail
          (match y
            (case Z (P x))
            (case (S z)
              (match x
                (case Z (N y))
                (case (S x2) (|-2| x2 z)))))))
      (match x
        (case Z
          (match y
            (case Z (P Z))
            (case (S x4) fail)))
        (case (S x3) fail))))
(define-fun
  plus2 :source Integers.plus
    ((x Integer) (y Integer)) Integer
    (match x
      (case (P m)
        (match y
          (case (P n) (P (plus m n)))
          (case (N o) (|-2| m (plus (S Z) o)))))
      (case (N m2)
        (match y
          (case (P n2) (|-2| n2 (plus (S Z) m2)))
          (case (N n3) (N (plus (plus (S Z) m2) n3)))))))
(prove
  :source Integers.prop_add_inv_right
  (forall ((x Integer)) (= (plus2 x (neg x)) zero)))
