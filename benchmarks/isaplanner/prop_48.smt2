; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
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
  butlast
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y z)
      (match z
        ((nil (_ nil a))
         ((cons x2 x3) (cons y (butlast z)))))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(prove
  (forall ((xs (list Nat)))
    (=>
      (not
        (match xs
          ((nil true)
           ((cons x y) false))))
      (= (++ (butlast xs) (cons (last xs) (_ nil Nat))) xs))))
