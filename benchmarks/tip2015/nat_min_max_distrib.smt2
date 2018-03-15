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
  :source Int.prop_min_max_distrib
  (forall ((x Nat) (y Nat) (z Nat))
    (= (let ((y2 (ite (leq y z) y z))) (ite (leq x y2) y2 x))
      (ite
        (leq x z)
        (@
          (let ((x3 (ite (leq x y) y x)))
            (lambda ((y4 Nat)) (ite (leq x3 y4) x3 y4)))
          z)
        (@
          (let ((x2 (ite (leq x y) y x)))
            (lambda ((y3 Nat)) (ite (leq x2 y3) x2 y3)))
          x)))))
