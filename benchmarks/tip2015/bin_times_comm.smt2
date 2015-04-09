; Binary natural numbers
(declare-datatypes
  () ((Bin (One) (ZeroAnd (ZeroAnd_ Bin)) (OneAnd (OneAnd_ Bin)))))
(define-funs-rec
  ((s ((x3 Bin)) Bin
      (match x3
        (case One (ZeroAnd x3))
        (case (ZeroAnd xs3) (OneAnd xs3))
        (case (OneAnd xs4) (ZeroAnd (s xs4)))))))
(define-funs-rec
  ((plus
      ((x4 Bin) (x5 Bin)) Bin
      (match x4
        (case One (s x5))
        (case
          (ZeroAnd ds)
          (match x5
            (case One (s x4))
            (case (ZeroAnd ys) (ZeroAnd (plus ds ys)))
            (case (OneAnd ys2) (OneAnd (plus ds ys2)))))
        (case
          (OneAnd ds2)
          (match x5
            (case One (s x4))
            (case (ZeroAnd ys3) (OneAnd (plus ds2 ys3)))
            (case (OneAnd ys4) (ZeroAnd (s (plus ds2 ys4))))))))))
(define-funs-rec
  ((times
      ((x Bin) (x2 Bin)) Bin
      (match x
        (case One x2)
        (case (ZeroAnd xs) (ZeroAnd (times xs x2)))
        (case (OneAnd xs2) (plus (ZeroAnd (times xs2 x2)) x2))))))
(assert
  (not (forall ((x6 Bin) (y Bin)) (= (times x6 y) (times y x6)))))
(check-sat)
