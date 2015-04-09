; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((lt ((x6 Nat) (x7 Nat)) bool))
  ((match x7
     (case Z false)
     (case
       (S ipv6)
       (match x6
         (case Z true)
         (case (S x8) (lt x8 ipv6)))))))
(define-funs-rec
  ((par (a2) (len ((x (list a2))) Nat)))
  ((match x
     (case nil Z)
     (case (cons ds xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((last ((x2 (list Nat))) Nat))
  ((match x2
     (case nil Z)
     (case
       (cons x3 ds2)
       (match ds2
         (case nil x3)
         (case (cons ipv ipv2) (last ds2)))))))
(define-funs-rec
  ((par (a3) (drop ((x4 Nat) (x5 (list a3))) (list a3))))
  ((match x4
     (case Z x5)
     (case
       (S ipv3)
       (match x5
         (case nil x5)
         (case (cons ipv4 ipv5) (as (drop ipv3 ipv5) (list a3))))))))
(assert
  (not
    (forall
      ((n Nat) (xs2 (list Nat)))
      (=> (lt n (len xs2)) (= (last (drop n xs2)) (last xs2))))))
(check-sat)
