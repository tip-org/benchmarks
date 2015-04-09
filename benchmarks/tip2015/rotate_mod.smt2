; Property about rotate and mod
(declare-datatypes () ((Nat (S (p Nat)) (Z))))
(declare-datatypes
  (a) ((List2 (Cons (Cons_ a) (Cons_2 (List2 a))) (Nil))))
(define-funs-rec
  ((par (a5) (take ((x14 Nat) (x15 (List2 a5))) (List2 a5))))
  ((match x14
     (case
       (S d8)
       (match x15
         (case (Cons d9 d10) (Cons d9 (as (take d8 d10) (List2 a5))))
         (case Nil x15)))
     (case Z (as Nil (List2 a5))))))
(define-funs-rec
  ((minus ((x4 Nat) (x5 Nat)) Nat))
  ((match x4
     (case
       (S d2)
       (match x5
         (case (S d3) (minus d2 d3))
         (case Z x4)))
     (case Z x4))))
(define-funs-rec
  ((lt ((x Nat) (x2 Nat)) bool))
  ((match x2
     (case
       (S d)
       (match x
         (case (S x3) (lt x3 d))
         (case Z true)))
     (case Z false))))
(define-funs-rec
  ((mod ((x6 Nat) (x7 Nat)) Nat))
  ((match x7
     (case (S d4) (ite (lt x6 x7) x6 (mod (minus x6 x7) x7)))
     (case Z x7))))
(define-funs-rec
  ((par (a2) (length ((x8 (List2 a2))) Nat)))
  ((match x8
     (case (Cons ds xs) (S (as (length xs) Nat)))
     (case Nil Z))))
(define-funs-rec
  ((par (a6) (drop ((x16 Nat) (x17 (List2 a6))) (List2 a6))))
  ((match x16
     (case
       (S d11)
       (match x17
         (case (Cons d12 d13) (as (drop d11 d13) (List2 a6)))
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
       (S d5)
       (match x13
         (case
           (Cons d6 d7)
           (as (rotate d5 (append d7 (Cons d6 (as Nil (List2 a4)))))
             (List2 a4)))
         (case Nil x13)))
     (case Z x13))))
(assert-not
  (par
    (a7)
    (forall
      ((n Nat) (xs3 (List2 a7)))
      (=
        (rotate n xs3)
        (append
          (drop (mod n (length xs3)) xs3)
          (take (mod n (length xs3)) xs3))))))
(check-sat)
