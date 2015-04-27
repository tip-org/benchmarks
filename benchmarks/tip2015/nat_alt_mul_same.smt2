; Property about an alternative multiplication function which exhibits an
; interesting recursion structure.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S n) (S (plus n y))))))
(define-funs-rec
  ((mult ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S n) (plus y (mult n y))))))
(define-funs-rec
  ((alt_mul ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S z)
       (match y
         (case Z y)
         (case (S x2) (S (plus (plus (alt_mul z x2) z) x2))))))))
(assert-not
  (forall ((x Nat)) (forall ((y Nat)) (= (alt_mul x y) (mult x y)))))
(check-sat)
