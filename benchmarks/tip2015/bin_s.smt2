; Property about natural numbers with binary presentation
(declare-datatype
  Bin
  ((One) (ZeroAnd (proj1-ZeroAnd Bin)) (OneAnd (proj1-OneAnd Bin))))
(define-fun-rec
  toNat
  ((x Bin)) Int
  (match x
    ((One 1)
     ((ZeroAnd xs) (+ (toNat xs) (toNat xs)))
     ((OneAnd ys) (+ (+ 1 (toNat ys)) (toNat ys))))))
(define-fun-rec
  s
  ((x Bin)) Bin
  (match x
    ((One (ZeroAnd One))
     ((ZeroAnd xs) (OneAnd xs))
     ((OneAnd ys) (ZeroAnd (s ys))))))
(prove (forall ((n Bin)) (= (toNat (s n)) (+ 1 (toNat n)))))
