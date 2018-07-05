; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (take
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z (_ nil a))
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (cons x2 (take z x3)))))))))
(define-fun-rec
  (par (a)
    (len
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (len xs)))))))
(define-fun-rec
  (par (a)
    (butlast
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y z)
           (match z
             (case nil (_ nil a))
             (case (cons x2 x3) (cons y (butlast z)))))))))
(define-fun-rec
  |-2|
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (|-2| z x2))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (= (butlast xs) (take (|-2| (len xs) (S Z)) xs)))))
