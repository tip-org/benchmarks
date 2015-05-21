; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((equal ((x Nat) (y Nat)) Bool))
  ((match x
     (case Z
       (match y
         (case Z true)
         (case (S z) false)))
     (case (S x2)
       (match y
         (case Z false)
         (case (S y2) (equal x2 y2)))))))
(define-funs-rec
  ((elem ((x Nat) (y (list Nat))) Bool))
  ((match y
     (case nil false)
     (case (cons z xs) (ite (equal x z) true (elem x xs))))))
(define-funs-rec
  ((subset ((x (list Nat)) (y (list Nat))) Bool))
  ((match x
     (case nil true)
     (case (cons z xs) (ite (elem z y) (subset xs y) false)))))
(define-funs-rec
  ((union ((x (list Nat)) (y (list Nat))) (list Nat)))
  ((match x
     (case nil y)
     (case (cons z xs)
       (ite (elem z y) (union xs y) (cons z (union xs y)))))))
(assert-not
  (forall ((x (list Nat)) (y (list Nat)))
    (=> (subset x y) (= (union x y) y))))
(check-sat)
