; Property about rotate and mod, written structurally recursive
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
       (S d11)
       (match x14
         (case (S d12) (minus d11 d12))
         (case Z x13)))
     (case Z x13))))
(define-funs-rec
  ((mod ((x5 Nat) (x6 Nat) (x7 Nat)) Nat))
  ((match x7
     (case
       (S d7)
       (match x5
         (case
           (S n)
           (match x6
             (case (S k) (mod n k x7))
             (case Z (mod n d7 x7))))
         (case
           Z
           (match x6
             (case (S n2) (minus x7 x6))
             (case Z x6)))))
     (case Z x7))))
(define-funs-rec ((mod2 ((x8 Nat) (x9 Nat)) Nat)) ((mod x8 Z x9)))
(define-funs-rec
  ((par (a5) (length ((x10 (List2 a5))) Nat)))
  ((match x10
     (case (Cons ds xs) (S (as (length xs) Nat)))
     (case Nil Z))))
(define-funs-rec
  ((par (a6) (drop ((x11 Nat) (x12 (List2 a6))) (List2 a6))))
  ((match x11
     (case
       (S d8)
       (match x12
         (case (Cons d9 d10) (as (drop d8 d10) (List2 a6)))
         (case Nil x12)))
     (case Z x12))))
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
      ((n3 Nat) (xs3 (List2 a7)))
      (=
        (rotate n3 xs3)
        (append
          (drop (mod2 n3 (length xs3)) xs3)
          (take (mod2 n3 (length xs3)) xs3))))))
(check-sat)
