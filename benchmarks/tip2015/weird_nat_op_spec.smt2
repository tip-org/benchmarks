; Weird functions over natural numbers
;
; Property about a 4-adic operation over natural numbers
; op a b c d = a * b + c + d
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-const (par (eta0) (error eta0)))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(define-fun-rec
  op
    ((x Nat) (y Nat) (z Nat) (x2 Nat)) Nat
    (let
      ((x3
          (match z
            (case Z
              (match x
                (case Z (as error Nat))
                (case (S a) (op a y y x2))))
            (case (S c) (op x y c (S x2))))))
      (match x
        (case Z
          (match z
            (case Z x2)
            (case (S x4) x3)))
        (case (S x5) x3))))
(define-fun-rec
  mult
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S n) (plus y (mult n y)))))
(assert-not
  (forall ((a Nat) (b Nat) (c Nat) (d Nat))
    (= (op a b c d) (plus (mult a b) (plus c d)))))
(check-sat)
