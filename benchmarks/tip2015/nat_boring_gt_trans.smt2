(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
(define-fun gt ((x Nat) (y Nat)) Bool (lt y x))
(prove
  :source Int.prop_boring_gt_trans
  (forall ((x Nat) (y Nat) (z Nat))
    (=> (gt x y) (=> (gt y z) (gt x z)))))
