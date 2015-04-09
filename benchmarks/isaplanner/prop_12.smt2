; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a2 b) (map2 ((x (=> a2 b)) (x2 (list a2))) (list b))))
  ((match x2
     (case nil (as nil (list b)))
     (case (cons x3 xs) (cons (@ x x3) (as (map2 x xs) (list b)))))))
(define-funs-rec
  ((par (a3) (drop ((x4 Nat) (x5 (list a3))) (list a3))))
  ((match x4
     (case Z x5)
     (case
       (S ipv)
       (match x5
         (case nil x5)
         (case (cons ipv2 ipv3) (as (drop ipv ipv3) (list a3))))))))
(assert-not
  (par
    (a4 a5)
    (forall
      ((n Nat) (f (=> a4 a5)) (xs2 (list a4)))
      (= (drop n (map2 f xs2)) (map2 f (drop n xs2))))))
(check-sat)
