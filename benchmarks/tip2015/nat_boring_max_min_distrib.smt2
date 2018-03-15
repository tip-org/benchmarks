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
  :source Int.prop_boring_max_min_distrib
  (forall ((x Nat) (y Nat) (z Nat))
    (= (let ((y2 (ite (leq y z) z y))) (ite (leq x y2) x y2))
      (ite
        (leq x z)
        (@
          (let ((x3 (ite (leq x y) x y)))
            (lambda ((y4 Nat)) (ite (leq x3 y4) y4 x3)))
          x)
        (@
          (let ((x2 (ite (leq x y) x y)))
            (lambda ((y3 Nat)) (ite (leq x2 y3) y3 x2)))
          z)))))
