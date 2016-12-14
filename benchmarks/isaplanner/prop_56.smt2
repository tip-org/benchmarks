; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (drop
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons x2 x3) (drop z x3))))))))
(define-fun-rec
  +2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (+2 z y)))))
(assert-not
  (par (a)
    (forall ((n Nat) (m Nat) (xs (list a)))
      (= (drop n (drop m xs)) (drop (+2 n m) xs)))))
(check-sat)
