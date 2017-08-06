; Property about natural numbers with binary presentation
(declare-datatypes ()
  ((Bin :source BinLists.Bin (One :source BinLists.One)
     (ZeroAnd :source BinLists.ZeroAnd (proj1-ZeroAnd Bin))
     (OneAnd :source BinLists.OneAnd (proj1-OneAnd Bin)))))
(define-fun-rec
  toNat :source BinLists.toNat
    ((x Bin)) Int
    (match x
      (case One 1)
      (case (ZeroAnd xs) (+ (toNat xs) (toNat xs)))
      (case (OneAnd ys) (+ (+ 1 (toNat ys)) (toNat ys)))))
(define-fun-rec
  s :source BinLists.s
    ((x Bin)) Bin
    (match x
      (case One (ZeroAnd One))
      (case (ZeroAnd xs) (OneAnd xs))
      (case (OneAnd ys) (ZeroAnd (s ys)))))
(prove
  :source BinLists.prop_s
  (forall ((n Bin)) (= (toNat (s n)) (+ 1 (toNat n)))))
