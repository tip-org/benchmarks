; Binary natural numbers
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes
  () ((Bin (One) (ZeroAnd (ZeroAnd_ Bin)) (OneAnd (OneAnd_ Bin)))))
(define-funs-rec
  ((s ((x4 Bin)) Bin))
  ((match x4
     (case One (ZeroAnd x4))
     (case (ZeroAnd xs5) (OneAnd xs5))
     (case (OneAnd xs6) (ZeroAnd (s xs6))))))
(define-funs-rec
  ((plus2 ((x5 Bin) (x6 Bin)) Bin))
  ((match x5
     (case One (s x6))
     (case
       (ZeroAnd ds)
       (match x6
         (case One (s x5))
         (case (ZeroAnd ys) (ZeroAnd (plus2 ds ys)))
         (case (OneAnd ys2) (OneAnd (plus2 ds ys2)))))
     (case
       (OneAnd ds2)
       (match x6
         (case One (s x5))
         (case (ZeroAnd ys3) (OneAnd (plus2 ds2 ys3)))
         (case (OneAnd ys4) (ZeroAnd (s (plus2 ds2 ys4)))))))))
(define-funs-rec
  ((times ((x2 Bin) (x3 Bin)) Bin))
  ((match x2
     (case One x3)
     (case (ZeroAnd xs3) (ZeroAnd (times xs3 x3)))
     (case (OneAnd xs4) (plus2 (ZeroAnd (times xs4 x3)) x3)))))
(define-funs-rec
  ((plus ((x7 Nat) (x8 Nat)) Nat))
  ((match x7
     (case Z x8)
     (case (S n) (S (plus n x8))))))
(define-funs-rec
  ((toNat ((x Bin)) Nat))
  ((match x
     (case One (S Z))
     (case (ZeroAnd xs) (plus (toNat xs) (toNat xs)))
     (case (OneAnd xs2) (S (plus (toNat xs2) (toNat xs2)))))))
(define-funs-rec
  ((mult ((x9 Nat) (x10 Nat)) Nat))
  ((match x9
     (case Z x9)
     (case (S n2) (plus x10 (mult n2 x10))))))
(assert-not
  (forall
    ((x11 Bin) (y Bin))
    (= (toNat (times x11 y)) (mult (toNat x11) (toNat y)))))
(check-sat)
