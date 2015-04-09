; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par
     (a2)
     (take
        ((x Nat) (x2 (list a2))) (list a2)
        (match x
          (case Z (as nil (list a2)))
          (case
            (S ipv)
            (match x2
              (case nil x2)
              (case
                (cons ipv2 ipv3) (cons ipv2 (as (take ipv ipv3) (list a2)))))))))))
(declare-sort a3 0)
(assert
  (not (forall ((xs (list a3))) (= (take Z xs) (as nil (list a3))))))
(check-sat)
