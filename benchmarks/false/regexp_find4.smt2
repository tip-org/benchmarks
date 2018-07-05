(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((T (A) (B) (C))))
(declare-datatypes (a)
  ((R (Nil)
     (Eps) (Atom (proj1-Atom a))
     (|:+:| (|proj1-:+:| (R a)) (|proj2-:+:| (R a)))
     (|:>:| (|proj1-:>:| (R a)) (|proj2-:>:| (R a)))
     (Star (proj1-Star (R a))))))
(define-fun-rec
  (par (a)
    (eps
       ((x (R a))) Bool
       (match x
         (case default false)
         (case Eps true)
         (case (|:+:| p q) (or (eps p) (eps q)))
         (case (|:>:| r q2) (and (eps r) (eps q2)))
         (case (Star y) true)))))
(define-fun-rec
  step
    ((x (R T)) (y T)) (R T)
    (match x
      (case default (_ Nil T))
      (case (Atom b) (ite (= b y) (_ Eps T) (_ Nil T)))
      (case (|:+:| p q) (|:+:| (step p y) (step q y)))
      (case (|:>:| r q2)
        (ite
          (eps r) (|:+:| (|:>:| (step r y) q2) (step q2 y))
          (|:+:| (|:>:| (step r y) q2) (_ Nil T))))
      (case (Star p2) (|:>:| (step p2 y) x))))
(define-fun-rec
  rec
    ((x (R T)) (y (list T))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (rec (step x z) xs))))
(prove
  (forall ((p (R T)))
    (not (rec p (cons A (cons B (cons B (cons A (_ nil T)))))))))
