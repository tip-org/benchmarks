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
  ((minus ((x8 Nat) (x9 Nat)) Nat))
  ((match x8
     (case Z x8)
     (case
       (S ipv7)
       (match x9
         (case Z x8)
         (case (S ipv8) (minus ipv7 ipv8)))))))
(define-funs-rec
  ((par (a5) (len ((x5 (list a5))) Nat)))
  ((match x5
     (case nil Z)
     (case (cons ds xs2) (S (as (len xs2) Nat))))))
(define-funs-rec
  ((par (a6) (drop ((x6 Nat) (x7 (list a6))) (list a6))))
  ((match x6
     (case Z x7)
     (case
       (S ipv4)
       (match x7
         (case nil x7)
         (case (cons ipv5 ipv6) (as (drop ipv4 ipv6) (list a6))))))))
(define-funs-rec
  ((par (a4) (append ((x10 (list a4)) (x11 (list a4))) (list a4))))
  ((match x10
     (case nil x11)
     (case (cons x12 xs3) (cons x12 (as (append xs3 x11) (list a4)))))))
(define-funs-rec
  ((par (a3) (rev ((x3 (list a3))) (list a3))))
  ((match x3
     (case nil x3)
     (case
       (cons x4 xs)
       (append (as (rev xs) (list a3)) (cons x4 (as nil (list a3))))))))
(assert-not
  (par
    (a7)
    (forall
      ((i Nat) (xs4 (list a7)))
      (= (rev (drop i xs4)) (take (minus (len xs4) i) (rev xs4))))))
(check-sat)
