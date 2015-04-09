; Property about rotate and mod
(declare-datatypes () ((Nat (S (p Nat)) (Z))))
(declare-datatypes
  (a) ((List2 (Cons (Cons_ a) (Cons_2 (List2 a))) (Nil))))
(define-funs-rec
  ((par (a2) (take ((x Nat) (x2 (List2 a2))) (List2 a2))))
  ((match x
     (case
       (S d)
       (match x2
         (case (Cons d2 d3) (Cons d2 (as (take d d3) (List2 a2))))
         (case Nil x2)))
     (case Z (as Nil (List2 a2))))))
(define-funs-rec
  ((minus ((x13 Nat) (x14 Nat)) Nat))
  ((match x13
     (case
       (S d12)
       (match x14
         (case (S d13) (minus d12 d13))
         (case Z x13)))
     (case Z x13))))
(define-funs-rec
  ((lt ((x10 Nat) (x11 Nat)) bool))
  ((match x11
     (case
       (S d11)
       (match x10
         (case (S x12) (lt x12 d11))
         (case Z true)))
     (case Z false))))
(define-funs-rec
  ((mod ((x5 Nat) (x6 Nat)) Nat))
  ((match x6
     (case (S d7) (ite (lt x5 x6) x5 (mod (minus x5 x6) x6)))
     (case Z x6))))
(define-funs-rec
  ((par (a5) (length ((x7 (List2 a5))) Nat)))
  ((match x7
     (case (Cons ds xs) (S (as (length xs) Nat)))
     (case Nil Z))))
(define-funs-rec
  ((par (a6) (drop ((x8 Nat) (x9 (List2 a6))) (List2 a6))))
  ((match x8
     (case
       (S d8)
       (match x9
         (case (Cons d9 d10) (as (drop d8 d10) (List2 a6)))
         (case Nil x9)))
     (case Z x9))))
(define-funs-rec
  ((par
     (a4) (append ((x15 (List2 a4)) (x16 (List2 a4))) (List2 a4))))
  ((match x15
     (case (Cons x17 xs2) (Cons x17 (as (append xs2 x16) (List2 a4))))
     (case Nil x16))))
(define-funs-rec
  ((par (a3) (rotate ((x3 Nat) (x4 (List2 a3))) (List2 a3))))
  ((match x3
     (case
       (S d4)
       (match x4
         (case
           (Cons d5 d6)
           (as (rotate d4 (append d6 (Cons d5 (as Nil (List2 a3)))))
             (List2 a3)))
         (case Nil x4)))
     (case Z x4))))
(declare-sort a7 0)
(assert
  (not
    (forall
      ((n Nat) (xs3 (List2 a7)))
      (=
        (rotate n xs3)
        (append
          (drop (mod n (length xs3)) xs3)
          (take (mod n (length xs3)) xs3))))))
(check-sat)
