; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (qrev
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (qrev xs (cons z y)))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  +2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (+2 z y)))))
(assert-not
  (par (a)
    (forall ((x (list a)) (y (list a)))
      (= (length (qrev x y)) (+2 (length x) (length y))))))
(check-sat)
