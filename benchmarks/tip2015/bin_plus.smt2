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
(define-fun-rec
  plus :source BinLists.plus
    ((x Bin) (y Bin)) Bin
    (match x
      (case One (s y))
      (case (ZeroAnd z)
        (match y
          (case One (s x))
          (case (ZeroAnd ys) (ZeroAnd (plus z ys)))
          (case (OneAnd xs) (OneAnd (plus z xs)))))
      (case (OneAnd x2)
        (match y
          (case One (s x))
          (case (ZeroAnd zs) (OneAnd (plus x2 zs)))
          (case (OneAnd ys2) (ZeroAnd (s (plus x2 ys2))))))))
(prove
  :source BinLists.prop_plus
  (forall ((x Bin) (y Bin))
    (= (toNat (plus x y)) (+ (toNat x) (toNat y)))))
