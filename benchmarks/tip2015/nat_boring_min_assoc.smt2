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
  :source Int.prop_boring_min_assoc
  (forall ((x Nat) (y Nat) (z Nat))
    (= (let ((y2 (ite (leq y z) y z))) (ite (leq x y2) x y2))
      (@
        (let ((x2 (ite (leq x y) x y)))
          (lambda ((y3 Nat)) (ite (leq x2 y3) x2 y3)))
        z))))
