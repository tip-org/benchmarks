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
  ((plus ((x5 Nat) (x6 Nat)) Nat))
  ((match x5
     (case Z x6)
     (case (S x7) (S (plus x7 x6))))))
(define-funs-rec
  ((par (a3) (drop ((x3 Nat) (x4 (list a3))) (list a3))))
  ((match x3
     (case Z x4)
     (case
       (S ipv4)
       (match x4
         (case nil x4)
         (case (cons ipv5 ipv6) (as (drop ipv4 ipv6) (list a3))))))))
(declare-sort a4 0)
(assert
  (not
    (forall
      ((n Nat) (m Nat) (xs (list a4)))
      (= (take n (drop m xs)) (drop m (take (plus n m) xs))))))
(check-sat)
