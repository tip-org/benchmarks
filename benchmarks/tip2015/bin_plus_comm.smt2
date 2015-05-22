; Property about natural numbers with binary presentation
(declare-datatypes ()
  ((Bin (One) (ZeroAnd (ZeroAnd_0 Bin)) (OneAnd (OneAnd_0 Bin)))))
(define-funs-rec
  ((s ((x Bin)) Bin))
  ((match x
     (case One (ZeroAnd One))
     (case (ZeroAnd xs) (OneAnd xs))
     (case (OneAnd ys) (ZeroAnd (s ys))))))
(define-funs-rec
  ((plus ((x Bin) (y Bin)) Bin))
  ((match x
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
         (case (OneAnd ys2) (ZeroAnd (s (plus x2 ys2)))))))))
(assert-not (forall ((x Bin) (y Bin)) (= (plus x y) (plus y x))))
(check-sat)
