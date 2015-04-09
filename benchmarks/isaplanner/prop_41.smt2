; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a2) (take ((x Nat) (x2 (list a2))) (list a2))))
  ((match x
     (case Z (as nil (list a2)))
     (case
       (S ipv)
       (match x2
         (case nil x2)
         (case
           (cons ipv2 ipv3) (cons ipv2 (as (take ipv ipv3) (list a2)))))))))
(define-funs-rec
  ((par (a3 b) (map2 ((x3 (=> a3 b)) (x4 (list a3))) (list b))))
  ((match x4
     (case nil (as nil (list b)))
     (case (cons x5 xs) (cons (@ x3 x5) (as (map2 x3 xs) (list b)))))))
(assert-not
  (par
    (a4 a5)
    (forall
      ((n Nat) (f (=> a4 a5)) (xs2 (list a4)))
      (= (take n (map2 f xs2)) (map2 f (take n xs2))))))
(check-sat)
