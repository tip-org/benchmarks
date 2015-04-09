; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par
     (a2 b2)
     (zip
        ((x (list a2)) (x2 (list b2))) (list (Pair a2 b2))
        (match x
          (case nil (as nil (list (Pair a2 b2))))
          (case
            (cons ipv ipv2)
            (match x2
              (case nil (as nil (list (Pair a2 b2))))
              (case
                (cons ipv3 ipv4)
                (cons
                  (Pair2 ipv ipv3) (as (zip ipv2 ipv4) (list (Pair a2 b2))))))))))))
(define-funs-rec
  ((par
     (a3)
     (take
        ((x3 Nat) (x4 (list a3))) (list a3)
        (match x3
          (case Z (as nil (list a3)))
          (case
            (S ipv5)
            (match x4
              (case nil x4)
              (case
                (cons ipv6 ipv7)
                (cons ipv6 (as (take ipv5 ipv7) (list a3)))))))))))
(declare-sort a4 0)
(declare-sort b3 0)
(assert
  (not
    (forall
      ((n Nat) (xs (list a4)) (ys (list b3)))
      (= (take n (zip xs ys)) (zip (take n xs) (take n ys))))))
(check-sat)
