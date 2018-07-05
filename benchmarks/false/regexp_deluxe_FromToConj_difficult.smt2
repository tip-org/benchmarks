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
  rep
    ((x (R T)) (y Int) (z Int)) (R T)
    (ite
      (= z 0) (ite (= y 0) (_ Eps T) (_ Nil T))
      (ite
        (= y 0) (|:>:| (|:+:| (_ Eps T) x) (rep x (- 0 1) (- z 1)))
        (|:>:| (|:+:| (_ Nil T) x) (rep x (- y 1) (- z 1))))))
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
  (forall
    ((p (R T)) (i1 Int) (|i'1| Int) (j1 Int) (|j'1| Int) (s (list T)))
    (=> (not (eps p))
      (= (rec (|:&:| (rep p i1 j1) (rep p |i'1| |j'1|)) s)
        (ite
          (<= i1 |i'1|)
          (ite
            (<= j1 |j'1|) (rec (rep p |i'1| j1) s) (rec (rep p |i'1| |j'1|) s))
          (ite
            (<= j1 |j'1|) (rec (rep p i1 j1) s) (rec (rep p i1 |j'1|) s)))))))
