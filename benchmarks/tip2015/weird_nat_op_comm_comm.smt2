; Weird functions over natural numbers
;
; Property about a 4-adic operation over natural numbers
; op a b c d = a * b + c + d
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  op
  ((x Nat) (y Nat) (z Nat) (x2 Nat)) Nat
  (let
    ((fail
        (match z
          ((zero (match x (((succ x4) (op x4 y y x2)))))
           ((succ x3) (op x y x3 (succ x2)))))))
    (match x
      ((zero
        (match z
          ((zero x2)
           ((succ x6) fail))))
       ((succ x5) fail)))))
(prove
  (forall ((a Nat) (b Nat) (c Nat) (d Nat))
    (= (op a b c d) (op b a d c))))
