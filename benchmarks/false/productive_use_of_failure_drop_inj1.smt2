(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (S (proj1-S Nat)) (Z))))
(define-fun-rec
  (par (a)
    (drop
       ((x Nat) (y (list a))) (list a)
       (match x
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (drop z x3))))
         (case Z y)))))
(prove
  (forall ((n Nat) (m Nat) (xs (list Nat)))
    (=> (= (drop n xs) (drop m xs)) (= n m))))
