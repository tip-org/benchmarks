(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((S (proj1-S Nat)) (Z)))
(define-fun-rec
  drop
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    (((S z)
      (match y
        ((nil (_ nil a))
         ((cons x2 x3) (drop z x3)))))
     (Z y))))
(prove
  (forall ((n Nat) (m Nat) (xs (list Nat)))
    (=> (= (drop n xs) (drop m xs)) (= n m))))
