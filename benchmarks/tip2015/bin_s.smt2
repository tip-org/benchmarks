; Property about natural numbers with binary presentation
(declare-datatypes ()
  ((Bin (One)
     (ZeroAnd (proj1-ZeroAnd Bin)) (OneAnd (proj1-OneAnd Bin)))))
(define-fun-rec
  toNat
    ((x Bin)) Int
    (match x
      (case One 1)
      (case (ZeroAnd xs) (+ (toNat xs) (toNat xs)))
      (case (OneAnd ys) (+ (+ 1 (toNat ys)) (toNat ys)))))
(define-fun-rec
  s ((x Bin)) Bin
    (match x
      (case One (ZeroAnd One))
      (case (ZeroAnd xs) (OneAnd xs))
      (case (OneAnd ys) (ZeroAnd (s ys)))))
(assert-not (forall ((n Bin)) (= (toNat (s n)) (+ 1 (toNat n)))))
(check-sat)
