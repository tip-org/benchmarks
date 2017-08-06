; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (length :source Definitions.length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  +2 :source Definitions.+
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (+2 z y)))))
(define-fun-rec
  (par (a)
    (++ :source Definitions.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (rev :source Definitions.rev
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ (rev xs) (cons y (_ nil a))))))))
(prove
  :source Properties.prop_T06
  (par (a)
    (forall ((x (list a)) (y (list a)))
      (= (length (rev (++ x y))) (+2 (length x) (length y))))))
