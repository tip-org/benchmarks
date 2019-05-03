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
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(prove
  (forall ((xs (list Nat)) (ys (list Nat)))
    (=> (= ys (_ nil Nat)) (= (last (++ xs ys)) (last xs)))))
