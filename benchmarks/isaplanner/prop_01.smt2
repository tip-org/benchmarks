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
(define-funs-rec
  ((par
     (a4)
     (append
        ((x5 (list a4)) (x6 (list a4))) (list a4)
        (match x5
          (case nil x6)
          (case (cons x7 xs) (cons x7 (as (append xs x6) (list a4)))))))))
(declare-sort a5 0)
(assert
  (not
    (forall
      ((n Nat) (xs2 (list a5)))
      (= (append (take n xs2) (drop n xs2)) xs2))))
(check-sat)
