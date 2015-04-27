; 2^n < n! for n > 3
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
  ((pow ((x Nat) (y Nat)) Nat))
  ((match y
     (case Z (S y))
     (case (S m) (mult x (pow x m))))))
(define-funs-rec
  ((lt ((x Nat) (y Nat)) bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (lt z x2)))))))
(define-funs-rec
  ((factorial ((x Nat)) Nat))
  ((match x
     (case Z (S x))
     (case (S n) (mult x (factorial n))))))
(assert-not
  (forall ((n Nat))
    (lt (pow (S (S Z)) (S (S (S (S n)))))
      (factorial (S (S (S (S n))))))))
(check-sat)
