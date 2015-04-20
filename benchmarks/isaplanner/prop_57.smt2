; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (take ((x Nat) (y (list a))) (list a))))
  ((match x
     (case Z (as nil (list a)))
     (case (S z)
       (match y
         (case nil y)
         (case (cons x2 x3) (cons x2 (as (take z x3) (list a)))))))))
(define-funs-rec
  ((minus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S z)
       (match y
         (case Z x)
         (case (S x2) (minus z x2)))))))
(define-funs-rec
  ((par (a) (drop ((x Nat) (y (list a))) (list a))))
  ((match x
     (case Z y)
     (case (S z)
       (match y
         (case nil y)
         (case (cons x2 x3) (as (drop z x3) (list a))))))))
(assert-not
  (par (a)
    (forall ((n Nat) (m Nat) (xs (list a)))
      (= (drop n (take m xs)) (take (minus m n) (drop n xs))))))
(check-sat)
