; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((minus ((x4 Nat) (x5 Nat)) Nat))
  ((match x4
     (case Z x4)
     (case
       (S ipv4)
       (match x5
         (case Z x4)
         (case (S ipv5) (minus ipv4 ipv5)))))))
(define-funs-rec
  ((par (a2) (len ((x (list a2))) Nat)))
  ((match x
     (case nil Z)
     (case (cons ds xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((par (a3) (drop ((x2 Nat) (x3 (list a3))) (list a3))))
  ((match x2
     (case Z x3)
     (case
       (S ipv)
       (match x3
         (case nil x3)
         (case (cons ipv2 ipv3) (as (drop ipv ipv3) (list a3))))))))
(define-funs-rec
  ((par (a4) (append ((x6 (list a4)) (x7 (list a4))) (list a4))))
  ((match x6
     (case nil x7)
     (case (cons x8 xs2) (cons x8 (as (append xs2 x7) (list a4)))))))
(declare-sort a5 0)
(assert
  (not
    (forall
      ((n Nat) (xs3 (list a5)) (ys (list a5)))
      (=
        (drop n (append xs3 ys))
        (append (drop n xs3) (drop (minus n (len xs3)) ys))))))
(check-sat)
