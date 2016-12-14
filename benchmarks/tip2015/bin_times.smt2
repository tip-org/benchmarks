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
(define-fun-rec
  plus
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
(define-fun-rec
  times
    ((x Bin) (y Bin)) Bin
    (match x
      (case One y)
      (case (ZeroAnd xs1) (ZeroAnd (times xs1 y)))
      (case (OneAnd xs12) (plus (ZeroAnd (times xs12 y)) y))))
(assert-not
  (forall ((x Bin) (y Bin))
    (= (toNat (times x y)) (* (toNat x) (toNat y)))))
(check-sat)
