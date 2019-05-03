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
    (forall ((n Nat) (xs (list a)))
      (= (len (drop n xs)) (|-2| (len xs) n)))))
