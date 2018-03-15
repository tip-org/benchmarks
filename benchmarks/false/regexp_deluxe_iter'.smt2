(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((T :source RegExpDeluxe.T (A :source RegExpDeluxe.A)
     (B :source RegExpDeluxe.B) (C :source RegExpDeluxe.C))))
(declare-datatypes (a)
  ((R :source RegExpDeluxe.R (Nil :source RegExpDeluxe.Nil)
     (Eps :source RegExpDeluxe.Eps)
     (Atom :source RegExpDeluxe.Atom (proj1-Atom a))
     (|:+:| :source |RegExpDeluxe.:+:| (|proj1-:+:| (R a))
       (|proj2-:+:| (R a)))
     (|:&:| :source |RegExpDeluxe.:&:| (|proj1-:&:| (R a))
       (|proj2-:&:| (R a)))
     (|:>:| :source |RegExpDeluxe.:>:| (|proj1-:>:| (R a))
       (|proj2-:>:| (R a)))
     (Star :source RegExpDeluxe.Star (proj1-Star (R a))))))
(define-fun-rec
  iter :source RegExpDeluxe.iter
    ((x Int) (y (R T))) (R T)
    (ite (= x 0) (_ Eps T) (|:>:| y (iter (- x 1) y))))
(define-fun-rec
  eps :source RegExpDeluxe.eps
    ((x (R T))) Bool
    (match x
      (case default false)
      (case Eps true)
      (case (|:+:| p q) (or (eps p) (eps q)))
      (case (|:&:| r q2) (and (eps r) (eps q2)))
      (case (|:>:| p2 q3) (and (eps p2) (eps q3)))
      (case (Star y) true)))
(define-fun
  .>. :source RegExpDeluxe..>.
    ((x (R T)) (y (R T))) (R T)
    (match x
      (case default
        (match y
          (case default
            (match x
              (case default
                (match y
                  (case default (|:>:| x y))
                  (case Eps x)))
              (case Eps y)))
          (case Nil (_ Nil T))))
      (case Nil (_ Nil T))))
(define-fun
  .+. :source RegExpDeluxe..+.
    ((x (R T)) (y (R T))) (R T)
    (match x
      (case default
        (match y
          (case default (|:+:| x y))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  step :source RegExpDeluxe.step
    ((x (R T)) (y T)) (R T)
    (match x
      (case default (_ Nil T))
      (case (Atom b) (ite (= b y) (_ Eps T) (_ Nil T)))
      (case (|:+:| p q) (.+. (step p y) (step q y)))
      (case (|:&:| r q2)
        (let ((wild1 (step r y)))
          (match wild1
            (case default
              (let ((wild2 (step q2 y)))
                (match wild2
                  (case default (|:&:| wild1 wild2))
                  (case Nil (_ Nil T)))))
            (case Nil (_ Nil T)))))
      (case (|:>:| p2 q3)
        (ite
          (eps p2) (.+. (.>. (step p2 y) q3) (step q3 y))
          (.+. (.>. (step p2 y) q3) (_ Nil T))))
      (case (Star p3) (.>. (step p3 y) x))))
(define-fun-rec
  rec :source RegExpDeluxe.rec
    ((x (R T)) (y (list T))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (rec (step x z) xs))))
(prove
  :source |RegExpDeluxe.prop_iter'|
  (forall ((i1 Int) (j1 Int) (p (R T)) (s (list T)))
    (=> (distinct i1 j1)
      (=> (not (eps p))
        (not
          (rec
            (let ((wild (iter i1 p)))
              (match wild
                (case default
                  (let ((wild1 (iter j1 p)))
                    (match wild1
                      (case default (|:&:| wild wild1))
                      (case Nil (_ Nil T)))))
                (case Nil (_ Nil T))))
            s))))))
