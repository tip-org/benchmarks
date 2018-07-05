(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((T (A) (B) (C))))
(declare-datatypes (a)
  ((R (Nil)
     (Eps) (Atom (proj1-Atom a))
     (|:+:| (|proj1-:+:| (R a)) (|proj2-:+:| (R a)))
     (|:&:| (|proj1-:&:| (R a)) (|proj2-:&:| (R a)))
     (|:>:| (|proj1-:>:| (R a)) (|proj2-:>:| (R a)))
     (Star (proj1-Star (R a))))))
(define-fun-rec
  iter
    ((x Int) (y (R T))) (R T)
    (ite (= x 0) (_ Eps T) (|:>:| y (iter (- x 1) y))))
(define-fun-rec
  eps
    ((x (R T))) Bool
    (match x
      (case default false)
      (case Eps true)
      (case (|:+:| p q) (or (eps p) (eps q)))
      (case (|:&:| r q2) (and (eps r) (eps q2)))
      (case (|:>:| p2 q3) (and (eps p2) (eps q3)))
      (case (Star y) true)))
(define-fun
  .>.
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
  .+.
    ((x (R T)) (y (R T))) (R T)
    (match x
      (case default
        (match y
          (case default (|:+:| x y))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  step
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
  rec
    ((x (R T)) (y (list T))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (rec (step x z) xs))))
(prove
  (forall ((i1 Int) (j1 Int) (p (R T)) (s (list T)))
    (=> (distinct i1 j1)
      (=> (not (eps p)) (not (rec (|:&:| (iter i1 p) (iter j1 p)) s))))))
