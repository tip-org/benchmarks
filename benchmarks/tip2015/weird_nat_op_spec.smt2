; Weird functions over natural numbers
;
; Property about a 4-adic operation over natural numbers
; op a b c d = a * b + c + d
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  times
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (plus y (times z y)))))
(define-fun-rec
  op :source WeirdInt.op
    ((x Nat) (y Nat) (z Nat) (x2 Nat)) Nat
    (let
      ((fail
          (match z
            (case Z (match x (case (S x4) (op x4 y y x2))))
            (case (S x3) (op x y x3 (S x2))))))
      (match x
        (case Z
          (match z
            (case Z x2)
            (case (S x6) fail)))
        (case (S x5) fail))))
(prove
  :source WeirdInt.prop_op_spec
  (forall ((a Nat) (b Nat) (c Nat) (d Nat))
    (= (op a b c d) (plus (plus (times a b) c) d))))
