; Regular expressions using Brzozowski derivatives (see the step function)
; The plus and seq functions are smart constructors.
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((A :source RegExp.A (X :source RegExp.X) (Y :source RegExp.Y))))
(declare-datatypes ()
  ((R :source RegExp.R (Nil :source RegExp.Nil)
     (Eps :source RegExp.Eps) (Atom :source RegExp.Atom (proj1-Atom A))
     (Plus :source RegExp.Plus (proj1-Plus R) (proj2-Plus R))
     (Seq :source RegExp.Seq (proj1-Seq R) (proj2-Seq R))
     (Star :source RegExp.Star (proj1-Star R)))))
(define-fun
  seq :source RegExp.seq
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
  plus :source RegExp.plus
    ((x R) (y R)) R
    (match x
      (case default
        (match y
          (case default (Plus x y))
          (case Nil x)))
      (case Nil y)))
(define-fun
  eqA :source RegExp.eqA
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
  eps :source RegExp.eps
    ((x R)) Bool
    (match x
      (case default false)
      (case Eps true)
      (case (Plus p q) (or (eps p) (eps q)))
      (case (Seq r q2) (and (eps r) (eps q2)))
      (case (Star y) true)))
(define-fun
  epsR :source RegExp.epsR ((x R)) R (ite (eps x) Eps Nil))
(define-fun-rec
  step :source RegExp.step
    ((x R) (y A)) R
    (match x
      (case default Nil)
      (case (Atom a) (ite (eqA a y) Eps Nil))
      (case (Plus p q) (plus (step p y) (step q y)))
      (case (Seq r q2)
        (plus (seq (step r y) q2) (seq (epsR r) (step q2 y))))
      (case (Star p2) (seq (step p2 y) x))))
(define-fun-rec
  recognise :source RegExp.recognise
    ((x R) (y (list A))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (recognise (step x z) xs))))
(prove
  :source RegExp.prop_RecEps
  (forall ((s (list A)))
    (= (recognise Eps s)
      (match s
        (case nil true)
        (case (cons x y) false)))))
