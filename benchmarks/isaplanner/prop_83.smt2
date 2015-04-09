; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par
     (a2 b2) (zip ((x (list a2)) (x2 (list b2))) (list (Pair a2 b2)))))
  ((match x
     (case nil (as nil (list (Pair a2 b2))))
     (case
       (cons ipv ipv2)
       (match x2
         (case nil (as nil (list (Pair a2 b2))))
         (case
           (cons ipv3 ipv4)
           (cons
             (Pair2 ipv ipv3) (as (zip ipv2 ipv4) (list (Pair a2 b2))))))))))
(define-funs-rec
  ((par (a3) (take ((x3 Nat) (x4 (list a3))) (list a3))))
  ((match x3
     (case Z (as nil (list a3)))
     (case
       (S ipv5)
       (match x4
         (case nil x4)
         (case
           (cons ipv6 ipv7) (cons ipv6 (as (take ipv5 ipv7) (list a3)))))))))
(define-funs-rec
  ((par (a4) (len ((x5 (list a4))) Nat)))
  ((match x5
     (case nil Z)
     (case (cons ds xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((par (a5) (drop ((x6 Nat) (x7 (list a5))) (list a5))))
  ((match x6
     (case Z x7)
     (case
       (S ipv8)
       (match x7
         (case nil x7)
         (case (cons ipv9 ipv10) (as (drop ipv8 ipv10) (list a5))))))))
(define-funs-rec
  ((par (a6) (append ((x8 (list a6)) (x9 (list a6))) (list a6))))
  ((match x8
     (case nil x9)
     (case (cons x10 xs2) (cons x10 (as (append xs2 x9) (list a6)))))))
(declare-sort a7 0)
(declare-sort b3 0)
(assert
  (not
    (forall
      ((xs3 (list a7)) (ys (list a7)) (zs (list b3)))
      (=
        (zip (append xs3 ys) zs)
        (append
          (zip xs3 (take (len xs3) zs)) (zip ys (drop (len xs3) zs)))))))
(check-sat)
