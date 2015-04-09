; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par
     (a2 b2) (zip ((x (list a2)) (x2 (list b2))) (list (Pair a2 b2)))))
  ((match x
     (case nil (as nil (list (Pair a2 b2))))
     (case
       (cons ipv ipv2)
       (match x2
         (case nil (as nil (list (Pair a2 b2))))
         (case
           (cons ipv3 ipv4)
           (cons
             (Pair2 ipv ipv3) (as (zip ipv2 ipv4) (list (Pair a2 b2))))))))))
(define-funs-rec
  ((par (a3) (drop ((x3 Nat) (x4 (list a3))) (list a3))))
  ((match x3
     (case Z x4)
     (case
       (S ipv5)
       (match x4
         (case nil x4)
         (case (cons ipv6 ipv7) (as (drop ipv5 ipv7) (list a3))))))))
(assert-not
  (par
    (a4 b3)
    (forall
      ((n Nat) (xs (list a4)) (ys (list b3)))
      (= (drop n (zip xs ys)) (zip (drop n xs) (drop n ys))))))
(check-sat)
