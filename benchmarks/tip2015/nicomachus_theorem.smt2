; Nichomacus' theorem
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S n) (S (plus n y))))))
(define-funs-rec
  ((sum ((x Nat)) Nat))
  ((match x
     (case Z x)
     (case (S n) (plus (sum n) x)))))
(define-funs-rec
  ((mult ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S n) (plus y (mult n y))))))
(define-funs-rec
  ((cubes ((x Nat)) Nat))
  ((match x
     (case Z x)
     (case (S n) (plus (cubes n) (mult (mult x x) x))))))
(assert-not
  (forall ((n Nat)) (= (cubes n) (mult (sum n) (sum n)))))
(check-sat)
