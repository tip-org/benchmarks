; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a b) (map2 ((x (=> a b)) (y (list a))) (list b))))
  ((match y
     (case nil (as nil (list b)))
     (case (cons z xs) (cons (@ x z) (as (map2 x xs) (list b)))))))
(define-funs-rec
  ((par (a) (drop ((x Nat) (y (list a))) (list a))))
  ((match x
     (case Z y)
     (case (S z)
       (match y
         (case nil y)
         (case (cons x2 x3) (as (drop z x3) (list a))))))))
(assert-not
  (par (a1 a)
    (forall ((n Nat) (f (=> a1 a)) (xs (list a1)))
      (= (drop n (map2 f xs)) (map2 f (drop n xs))))))
(check-sat)
