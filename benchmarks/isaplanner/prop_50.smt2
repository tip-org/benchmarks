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
  ((minus ((x6 Nat) (x7 Nat)) Nat))
  ((match x6
     (case Z x6)
     (case
       (S ipv6)
       (match x7
         (case Z x6)
         (case (S ipv7) (minus ipv6 ipv7)))))))
(define-funs-rec
  ((par (a3) (len ((x3 (list a3))) Nat)))
  ((match x3
     (case nil Z)
     (case (cons ds xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((par (a4) (butlast ((x4 (list a4))) (list a4))))
  ((match x4
     (case nil x4)
     (case
       (cons x5 ds2)
       (match ds2
         (case nil ds2)
         (case (cons ipv4 ipv5) (cons x5 (as (butlast ds2) (list a4)))))))))
(declare-sort a5 0)
(assert
  (not
    (forall
      ((xs2 (list a5)))
      (= (butlast xs2) (take (minus (len xs2) (S Z)) xs2)))))
(check-sat)
