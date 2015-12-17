; Regular expressions using Brzozowski derivatives (see the step function)
; This version does not use smart constructors.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes ()
  ((R (Nil)
     (Eps) (Atom (Atom_0 A)) (Plus (Plus_0 R) (Plus_1 R))
     (And (And_0 R) (And_1 R)) (Seq (Seq_0 R) (Seq_1 R))
     (Star (Star_0 R)))))
(define-fun
  eqA
    ((x A) (y A)) Bool
    (match x
      (case X
        (match y
          (case X true)
          (case Y false)))
      (case Y
        (match y
          (case X false)
          (case Y true)))))
(define-fun-rec
  eps
    ((x R)) Bool
    (match x
      (case default false)
      (case Eps true)
      (case (Plus p q) (or (eps p) (eps q)))
      (case (And r q2) (and (eps r) (eps q2)))
      (case (Seq p2 q3) (and (eps p2) (eps q3)))
      (case (Star y) true)))
(define-fun epsR ((x R)) R (ite (eps x) Eps Nil))
(define-fun-rec
  step
    ((x R) (y A)) R
    (match x
      (case default Nil)
      (case (Atom a) (ite (eqA a y) Eps Nil))
      (case (Plus p q) (Plus (step p y) (step q y)))
      (case (And r q2) (And (step r y) (step q2 y)))
      (case (Seq p2 q3)
        (Plus (Seq (step p2 y) q3) (Seq (epsR p2) (step q3 y))))
      (case (Star p3) (Seq (step p3 y) x))))
(define-fun-rec
  recognise
    ((x R) (y (list A))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (recognise (step x z) xs))))
(define-fun-rec
  deeps
    ((x R)) R
    (match x
      (case Nil Nil)
      (case Eps Nil)
      (case (Atom a) x)
      (case (Plus p q) (Plus (deeps p) (deeps q)))
      (case (And r q2) (And (deeps r) (deeps q2)))
      (case (Seq p2 q3)
        (ite (and (eps p2) (eps q3)) (Plus (deeps p2) (deeps q3)) x))
      (case (Star p3) (deeps p3))))
(assert-not
  (forall ((p R) (s (list A)))
    (= (recognise (Star p) s) (recognise (Star (deeps p)) s))))
(check-sat)
