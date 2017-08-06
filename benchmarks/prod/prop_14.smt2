; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
;
; This property is the same as isaplanner #78
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  <=2 :source Definitions.<=
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (<=2 z x2))))))
(define-fun-rec
  insert :source Definitions.insert
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (cons x (_ nil Nat)))
      (case (cons z xs)
        (ite (<=2 x z) (cons x y) (cons z (insert x xs))))))
(define-fun-rec
  isort :source Definitions.isort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons y xs) (insert y (isort xs)))))
(define-fun
  && :source Definitions.&& ((x Bool) (y Bool)) Bool (ite x y false))
(define-fun-rec
  sorted :source Definitions.sorted
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (&& (<=2 y y2) (sorted z)))))))
(prove
  :source Properties.prop_T14
  (forall ((x (list Nat))) (sorted (isort x))))
