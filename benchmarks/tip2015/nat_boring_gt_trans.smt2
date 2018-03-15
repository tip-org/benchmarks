(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  lt :definition :source |<|
    ((x Nat) (y Nat)) Bool
    (match y
      (case zero false)
      (case (succ z)
        (match x
          (case zero true)
          (case (succ n) (lt n z))))))
(define-fun
  gt :definition :source |>| ((x Nat) (y Nat)) Bool (lt y x))
(prove
  :source Int.prop_boring_gt_trans
  (forall ((x Nat) (y Nat) (z Nat))
    (=> (gt x y) (=> (gt y z) (gt x z)))))
