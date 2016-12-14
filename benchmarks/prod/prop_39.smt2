; Property from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun x ((y Bool) (z Bool)) Bool (ite y true z))
(define-fun-rec
  (par (a)
    (drop
       ((y Nat) (z (list a))) (list a)
       (match y
         (case Z z)
         (case (S x2)
           (match z
             (case nil (as nil (list a)))
             (case (cons x3 x4) (drop x2 x4))))))))
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
(assert-not
  (forall ((y Nat) (z Nat) (z2 (list Nat)))
    (=> (elem y (drop z z2)) (elem y z2))))
(check-sat)
