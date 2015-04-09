; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par
     (a2)
     (null
        ((x (list a2))) bool
        (match x
          (case nil true)
          (case (cons ipv ipv2) false))))))
(define-funs-rec
  ((last
      ((x2 (list Nat))) Nat
      (match x2
        (case nil Z)
        (case
          (cons x3 ds)
          (match ds
            (case nil x3)
            (case (cons ipv3 ipv4) (last ds))))))))
(define-funs-rec
  ((par
     (a3)
     (butlast
        ((x4 (list a3))) (list a3)
        (match x4
          (case nil x4)
          (case
            (cons x5 ds2)
            (match ds2
              (case nil ds2)
              (case
                (cons ipv5 ipv6) (cons x5 (as (butlast ds2) (list a3)))))))))))
(define-funs-rec
  ((par
     (a4)
     (append
        ((x6 (list a4)) (x7 (list a4))) (list a4)
        (match x6
          (case nil x7)
          (case (cons x8 xs) (cons x8 (as (append xs x7) (list a4)))))))))
(assert
  (not
    (forall
      ((xs2 (list Nat)))
      (=>
        (not (null xs2))
        (=
          (append (butlast xs2) (cons (last xs2) (as nil (list Nat))))
          xs2)))))
(check-sat)
