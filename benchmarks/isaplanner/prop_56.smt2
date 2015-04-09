; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus
      ((x3 Nat) (x4 Nat)) Nat
      (match x3
        (case Z x4)
        (case (S x5) (S (plus x5 x4)))))))
(define-funs-rec
  ((par
     (a2)
     (drop
        ((x Nat) (x2 (list a2))) (list a2)
        (match x
          (case Z x2)
          (case
            (S ipv)
            (match x2
              (case nil x2)
              (case (cons ipv2 ipv3) (as (drop ipv ipv3) (list a2))))))))))
(declare-sort a3 0)
(assert
  (not
    (forall
      ((n Nat) (m Nat) (xs (list a3)))
      (= (drop n (drop m xs)) (drop (plus n m) xs)))))
(check-sat)
