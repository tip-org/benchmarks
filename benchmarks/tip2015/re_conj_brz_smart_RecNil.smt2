; Regular expressions using Brzozowski derivatives (see the step function)
; The plus and seq functions are smart constructors.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes ()
  ((R (Nil)
     (Eps) (Atom (Atom_0 A)) (Plus (Plus_0 R) (Plus_1 R))
     (And (And_0 R) (And_1 R)) (Seq (Seq_0 R) (Seq_1 R))
     (Star (Star_0 R)))))
(define-fun
  seq
    ((x R) (y R)) R
    (match x
      (case default
        (match y
          (case default
            (match x
              (case default
                (match y
                  (case default (Seq x y))
                  (case Eps x)))
              (case Eps y)))
          (case Nil Nil)))
      (case Nil Nil)))
(define-fun
  plus
    ((x R) (y R)) R
    (match x
      (case default
        (match y
          (case default (Plus x y))
          (case Nil x)))
      (case Nil y)))
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
      (case (And p2 q2) (and (eps p2) (eps q2)))
      (case (Seq p3 q3) (and (eps p3) (eps q3)))
      (case (Star y) true)))
(define-fun epsR ((x R)) R (ite (eps x) Eps Nil))
(define-fun
  conj
    ((x R) (y R)) R
    (match x
      (case default
        (match y
          (case default (And x y))
          (case Nil Nil)))
      (case Nil Nil)))
(define-fun-rec
  step
    ((x R) (y A)) R
    (match x
      (case default Nil)
      (case (Atom a) (ite (eqA a y) Eps Nil))
      (case (Plus p q) (plus (step p y) (step q y)))
      (case (And p2 q2) (conj (step p2 y) (step q2 y)))
      (case (Seq p3 q3)
        (plus (seq (step p3 y) q3) (seq (epsR p3) (step q3 y))))
      (case (Star p4) (seq (step p4 y) x))))
(define-fun-rec
  recognise
    ((x R) (y (list A))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (recognise (step x z) xs))))
(assert-not (forall ((s (list A))) (not (recognise Nil s))))
(check-sat)
