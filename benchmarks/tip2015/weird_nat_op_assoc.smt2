; Weird functions over natural numbers
;
; Property about a 4-adic operation over natural numbers
; op a b c d = a * b + c + d
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
  :source WeirdInt.prop_op_assoc
  (forall ((a Nat) (b Nat) (c Nat) (d Nat) (e Nat))
    (= (op (op a b Z Z) c d e) (op a (op b c Z Z) d e))))
