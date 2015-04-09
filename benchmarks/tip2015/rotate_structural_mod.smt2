; Property about rotate and mod, written structurally recursive
(declare-datatypes () ((Nat (S (p Nat)) (Z))))
(declare-datatypes
  (a) ((List2 (Cons (Cons_ a) (Cons_2 (List2 a))) (Nil))))
(define-funs-rec
  ((par (a5) (take ((x14 Nat) (x15 (List2 a5))) (List2 a5))))
  ((match x14
     (case
       (S d7)
       (match x15
         (case (Cons d8 d9) (Cons d8 (as (take d7 d9) (List2 a5))))
         (case Nil x15)))
     (case Z (as Nil (List2 a5))))))
(define-funs-rec
  ((minus ((x Nat) (x2 Nat)) Nat))
  ((match x
     (case
       (S d)
       (match x2
         (case (S d2) (minus d d2))
         (case Z x)))
     (case Z x))))
(define-funs-rec
  ((mod2 ((x5 Nat) (x6 Nat) (x7 Nat)) Nat))
  ((match x7
     (case
       (S d3)
       (match x5
         (case
           (S n)
           (match x6
             (case (S k) (mod2 n k x7))
             (case Z (mod2 n d3 x7))))
         (case
           Z
           (match x6
             (case (S n2) (minus x7 x6))
             (case Z x6)))))
     (case Z x7))))
(define-funs-rec ((mod ((x3 Nat) (x4 Nat)) Nat)) ((mod2 x3 Z x4)))
(define-funs-rec
  ((par (a2) (length ((x8 (List2 a2))) Nat)))
  ((match x8
     (case (Cons ds xs) (S (as (length xs) Nat)))
     (case Nil Z))))
(define-funs-rec
  ((par (a6) (drop ((x16 Nat) (x17 (List2 a6))) (List2 a6))))
  ((match x16
     (case
       (S d10)
       (match x17
         (case (Cons d11 d12) (as (drop d10 d12) (List2 a6)))
         (case Nil x17)))
     (case Z x17))))
(define-funs-rec
  ((par (a3) (append ((x9 (List2 a3)) (x10 (List2 a3))) (List2 a3))))
  ((match x9
     (case (Cons x11 xs2) (Cons x11 (as (append xs2 x10) (List2 a3))))
     (case Nil x10))))
(define-funs-rec
  ((par (a4) (rotate ((x12 Nat) (x13 (List2 a4))) (List2 a4))))
  ((match x12
     (case
       (S d4)
       (match x13
         (case
           (Cons d5 d6)
           (as (rotate d4 (append d6 (Cons d5 (as Nil (List2 a4)))))
             (List2 a4)))
         (case Nil x13)))
     (case Z x13))))
(assert-not
  (par
    (a7)
    (forall
      ((n3 Nat) (xs3 (List2 a7)))
      (=
        (rotate n3 xs3)
        (append
          (drop (mod n3 (length xs3)) xs3)
          (take (mod n3 (length xs3)) xs3))))))
(check-sat)
