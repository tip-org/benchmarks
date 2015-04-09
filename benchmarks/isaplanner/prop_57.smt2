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
(define-funs-rec
  ((minus
      ((x5 Nat) (x6 Nat)) Nat
      (match x5
        (case Z x5)
        (case
          (S ipv7)
          (match x6
            (case Z x5)
            (case (S ipv8) (minus ipv7 ipv8))))))))
(define-funs-rec
  ((par
     (a3)
     (drop
        ((x3 Nat) (x4 (list a3))) (list a3)
        (match x3
          (case Z x4)
          (case
            (S ipv4)
            (match x4
              (case nil x4)
              (case (cons ipv5 ipv6) (as (drop ipv4 ipv6) (list a3))))))))))
(declare-sort a4 0)
(assert
  (not
    (forall
      ((n Nat) (m Nat) (xs (list a4)))
      (= (drop n (take m xs)) (take (minus m n) (drop n xs))))))
(check-sat)
