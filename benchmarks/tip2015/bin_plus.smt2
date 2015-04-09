; Binary natural numbers
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes
  () ((Bin (One) (ZeroAnd (ZeroAnd_ Bin)) (OneAnd (OneAnd_ Bin)))))
(define-funs-rec
  ((s ((x2 Bin)) Bin))
  ((match x2
     (case One (ZeroAnd x2))
     (case (ZeroAnd xs3) (OneAnd xs3))
     (case (OneAnd xs4) (ZeroAnd (s xs4))))))
(define-funs-rec
  ((plus2 ((x3 Bin) (x4 Bin)) Bin))
  ((match x3
     (case One (s x4))
     (case
       (ZeroAnd ds)
       (match x4
         (case One (s x3))
         (case (ZeroAnd ys) (ZeroAnd (plus2 ds ys)))
         (case (OneAnd ys2) (OneAnd (plus2 ds ys2)))))
     (case
       (OneAnd ds2)
       (match x4
         (case One (s x3))
         (case (ZeroAnd ys3) (OneAnd (plus2 ds2 ys3)))
         (case (OneAnd ys4) (ZeroAnd (s (plus2 ds2 ys4)))))))))
(define-funs-rec
  ((plus ((x5 Nat) (x6 Nat)) Nat))
  ((match x5
     (case Z x6)
     (case (S n) (S (plus n x6))))))
(define-funs-rec
  ((toNat ((x Bin)) Nat))
  ((match x
     (case One (S Z))
     (case (ZeroAnd xs) (plus (toNat xs) (toNat xs)))
     (case (OneAnd xs2) (S (plus (toNat xs2) (toNat xs2)))))))
(assert
  (not
    (forall
      ((x7 Bin) (y Bin))
      (= (toNat (plus2 x7 y)) (plus (toNat x7) (toNat y))))))
(check-sat)
