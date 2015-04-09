; Nicomachus's theorem
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (x2 Nat)) Nat))
  ((match x
     (case Z x2)
     (case (S n) (S (plus n x2))))))
(define-funs-rec
  ((sum ((x5 Nat)) Nat))
  ((match x5
     (case Z x5)
     (case (S n3) (plus (sum n3) x5)))))
(define-funs-rec
  ((mult ((x3 Nat) (x4 Nat)) Nat))
  ((match x3
     (case Z x3)
     (case (S n2) (plus x4 (mult n2 x4))))))
(define-funs-rec
  ((cubes ((x6 Nat)) Nat))
  ((match x6
     (case Z x6)
     (case (S n4) (plus (cubes n4) (mult (mult x6 x6) x6))))))
(assert
  (not (forall ((n5 Nat)) (= (cubes n5) (mult (sum n5) (sum n5))))))
(check-sat)
