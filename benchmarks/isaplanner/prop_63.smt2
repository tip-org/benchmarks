; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  len
  (par (a) (((x (list a))) Nat))
  (match x
    ((nil Z)
     ((cons y xs) (S (len xs))))))
(define-fun-rec
  last
  ((x (list Nat))) Nat
  (match x
    ((nil Z)
     ((cons y z)
      (match z
        ((nil y)
         ((cons x2 x3) (last z))))))))
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
  <2
  ((x Nat) (y Nat)) Bool
  (match y
    ((Z false)
     ((S z)
      (match x
        ((Z true)
         ((S x2) (<2 x2 z))))))))
(prove
  (forall ((n Nat) (xs (list Nat)))
    (=> (<2 n (len xs)) (= (last (drop n xs)) (last xs)))))
