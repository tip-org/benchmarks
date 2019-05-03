; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  take
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((Z (_ nil a))
     ((S z)
      (match y
        ((nil (_ nil a))
         ((cons x2 x3) (cons x2 (take z x3)))))))))
(define-fun-rec
  drop
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((Z y)
     ((S z)
      (match y
        ((nil (_ nil a))
         ((cons x2 x3) (drop z x3))))))))
(define-fun-rec
  |-2|
  ((x Nat) (y Nat)) Nat
  (match x
    ((Z Z)
     ((S z)
      (match y
        ((Z x)
         ((S x2) (|-2| z x2))))))))
(prove
  (par (a)
    (forall ((n Nat) (m Nat) (xs (list a)))
      (= (drop n (take m xs)) (take (|-2| m n) (drop n xs))))))
