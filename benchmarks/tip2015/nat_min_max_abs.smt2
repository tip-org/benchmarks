(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  leq :definition :source |<=|
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(prove
  :source Int.prop_min_max_abs
  (forall ((x Nat) (y Nat))
    (= (let ((z (ite (leq x y) y x))) (ite (leq x z) x z)) x)))
