; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
;
; This property is the same as isaplanner #78
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
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
(define-fun
  &&
  ((x Bool) (y Bool)) Bool (ite x y false))
(define-fun-rec
  sorted
  ((x (list Nat))) Bool
  (match x
    ((nil true)
     ((cons y z)
      (match z
        ((nil true)
         ((cons y2 xs) (&& (<=2 y y2) (sorted z)))))))))
(prove (forall ((x (list Nat))) (sorted (isort x))))
