; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  x-
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (x- z x2))))))
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
         (case nil (as nil (list a)))
         (case (cons y z)
           (match z
             (case nil (as nil (list a)))
             (case (cons x2 x3) (cons y (butlast z)))))))))
(assert-not
  (par (a)
    (forall ((xs (list a)))
      (= (len (butlast xs)) (x- (len xs) (S Z))))))
(check-sat)
