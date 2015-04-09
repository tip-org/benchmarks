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
  ((minus ((x4 Nat) (x5 Nat)) Nat))
  ((match x4
     (case Z x4)
     (case
       (S ipv4)
       (match x5
         (case Z x4)
         (case (S ipv5) (minus ipv4 ipv5)))))))
(define-funs-rec
  ((par (a3) (len ((x3 (list a3))) Nat)))
  ((match x3
     (case nil Z)
     (case (cons ds xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((par (a4) (append ((x6 (list a4)) (x7 (list a4))) (list a4))))
  ((match x6
     (case nil x7)
     (case (cons x8 xs2) (cons x8 (as (append xs2 x7) (list a4)))))))
(assert-not
  (par
    (a5)
    (forall
      ((n Nat) (xs3 (list a5)) (ys (list a5)))
      (=
        (take n (append xs3 ys))
        (append (take n xs3) (take (minus n (len xs3)) ys))))))
(check-sat)
