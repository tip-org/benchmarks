; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((minus ((x4 Nat) (x5 Nat)) Nat))
  ((match x4
     (case Z x4)
     (case
       (S ipv3)
       (match x5
         (case Z x4)
         (case (S ipv4) (minus ipv3 ipv4)))))))
(define-funs-rec
  ((par (a2) (len ((x (list a2))) Nat)))
  ((match x
     (case nil Z)
     (case (cons ds xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((par (a3) (butlast ((x2 (list a3))) (list a3))))
  ((match x2
     (case nil x2)
     (case
       (cons x3 ds2)
       (match ds2
         (case nil ds2)
         (case (cons ipv ipv2) (cons x3 (as (butlast ds2) (list a3)))))))))
(assert-not
  (par
    (a4)
    (forall
      ((xs2 (list a4)))
      (= (len (butlast xs2)) (minus (len xs2) (S Z))))))
(check-sat)
