; Weird functions over natural numbers
;
; Property about a 4-adic operation over natural numbers
; op a b c d = a * b + c + d
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  op
    ((x Nat) (y Nat) (z Nat) (x2 Nat)) Nat
    (let
      ((fail
          (match z
            (case zero (match x (case (succ x4) (op x4 y y x2))))
            (case (succ x3) (op x y x3 (succ x2))))))
      (match x
        (case zero
          (match z
            (case zero x2)
            (case (succ x6) fail)))
        (case (succ x5) fail))))
(prove
  (forall ((a Nat) (b Nat) (c Nat) (d Nat) (e Nat))
    (= (op (op a b zero zero) c d e) (op a (op b c zero zero) d e))))
