; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (len
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (len xs)))))))
(define-fun-rec
  last
    ((x (list Nat))) Nat
    (match x
      (case nil Z)
      (case (cons y z)
        (match z
          (case nil y)
          (case (cons x2 x3) (last z))))))
(define-fun-rec
  (par (a)
    (drop
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (drop z x3))))))))
(define-fun-rec
  <2
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S x2) (<2 x2 z))))))
(prove
  (forall ((n Nat) (xs (list Nat)))
    (=> (<2 n (len xs)) (= (last (drop n xs)) (last xs)))))
