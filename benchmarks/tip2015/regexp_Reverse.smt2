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
(define-fun-rec
  rev :source RegExp.rev
    ((x R)) R
    (match x
      (case default x)
      (case (Plus a b) (Plus (rev a) (rev b)))
      (case (Seq c b2) (Seq (rev b2) (rev c)))
      (case (Star a2) (Star (rev a2)))))
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
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (reverse :let :source Prelude.reverse
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ (reverse xs) (cons y (_ nil a))))))))
(prove
  :source RegExp.prop_Reverse
  (forall ((r R) (s (list A)))
    (= (recognise (rev r) s) (recognise r (reverse s)))))
