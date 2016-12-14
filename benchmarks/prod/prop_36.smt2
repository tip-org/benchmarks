; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun x ((y Bool) (z Bool)) Bool (ite y true z))
(define-fun-rec
  ==
    ((y Nat) (z Nat)) Bool
    (match y
      (case Z
        (match z
          (case Z true)
          (case (S x2) false)))
      (case (S x3)
        (match z
          (case Z false)
          (case (S y2) (== x3 y2))))))
(define-fun-rec
  elem
    ((y Nat) (z (list Nat))) Bool
    (match z
      (case nil false)
      (case (cons x2 xs) (x (== y x2) (elem y xs)))))
(define-fun-rec
  (par (a)
    (++
       ((y (list a)) (z (list a))) (list a)
       (match y
         (case nil z)
         (case (cons x2 xs) (cons x2 (++ xs z)))))))
(assert-not
  (forall ((y Nat) (z (list Nat)) (z2 (list Nat)))
    (=> (elem y z) (elem y (++ z z2)))))
(check-sat)
