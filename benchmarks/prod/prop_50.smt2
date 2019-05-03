; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
;
; This property is the same as isaplanner #53
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  ==
  ((x Nat) (y Nat)) Bool
  (match x
    ((Z
      (match y
        ((Z true)
         ((S z) false))))
     ((S x2)
      (match y
        ((Z false)
         ((S y2) (== x2 y2))))))))
(define-fun-rec
  count
  ((x Nat) (y (list Nat))) Nat
  (match y
    ((nil Z)
     ((cons z xs) (ite (== x z) (S (count x xs)) (count x xs))))))
(define-fun-rec
  <=2
  ((x Nat) (y Nat)) Bool
  (match x
    ((Z true)
     ((S z)
      (match y
        ((Z false)
         ((S x2) (<=2 z x2))))))))
(define-fun-rec
  insert
  ((x Nat) (y (list Nat))) (list Nat)
  (match y
    ((nil (cons x (_ nil Nat)))
     ((cons z xs) (ite (<=2 x z) (cons x y) (cons z (insert x xs)))))))
(define-fun-rec
  isort
  ((x (list Nat))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons y xs) (insert y (isort xs))))))
(prove
  (forall ((x Nat) (y (list Nat)))
    (= (count x (isort y)) (count x y))))
