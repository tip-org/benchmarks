; Binary natural numbers
(declare-datatypes
  () ((Bin (One) (ZeroAnd (ZeroAnd_ Bin)) (OneAnd (OneAnd_ Bin)))))
(define-funs-rec
  ((s ((x Bin)) Bin))
  ((match x
     (case One (ZeroAnd x))
     (case (ZeroAnd xs) (OneAnd xs))
     (case (OneAnd xs2) (ZeroAnd (s xs2))))))
(define-funs-rec
  ((plus ((x2 Bin) (x3 Bin)) Bin))
  ((match x2
     (case One (s x3))
     (case
       (ZeroAnd ds)
       (match x3
         (case One (s x2))
         (case (ZeroAnd ys) (ZeroAnd (plus ds ys)))
         (case (OneAnd ys2) (OneAnd (plus ds ys2)))))
     (case
       (OneAnd ds2)
       (match x3
         (case One (s x2))
         (case (ZeroAnd ys3) (OneAnd (plus ds2 ys3)))
         (case (OneAnd ys4) (ZeroAnd (s (plus ds2 ys4)))))))))
(assert
  (not (forall ((x4 Bin) (y Bin)) (= (plus x4 y) (plus y x4)))))
(check-sat)
