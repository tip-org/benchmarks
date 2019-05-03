(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype T ((A) (B) (C)))
(declare-datatype
  R
  (par (a)
    ((Nil) (Eps) (Atom (proj1-Atom a))
     (|:+:| (|proj1-:+:| (R a)) (|proj2-:+:| (R a)))
     (|:>:| (|proj1-:>:| (R a)) (|proj2-:>:| (R a)))
     (Star (proj1-Star (R a))))))
(define-fun-rec
  eps
  (par (a) (((x (R a))) Bool))
  (match x
    ((_ false)
     (Eps true)
     ((|:+:| p q) (or (eps p) (eps q)))
     ((|:>:| r q2) (and (eps r) (eps q2)))
     ((Star y) true))))
(define-fun-rec
  step
  ((x (R T)) (y T)) (R T)
  (match x
    ((_ (_ Nil T))
     ((Atom b) (ite (= b y) (_ Eps T) (_ Nil T)))
     ((|:+:| p q) (|:+:| (step p y) (step q y)))
     ((|:>:| r q2)
      (ite
        (eps r) (|:+:| (|:>:| (step r y) q2) (step q2 y))
        (|:+:| (|:>:| (step r y) q2) (_ Nil T))))
     ((Star p2) (|:>:| (step p2 y) x)))))
(define-fun-rec
  rec
  ((x (R T)) (y (list T))) Bool
  (match y
    ((nil (eps x))
     ((cons z xs) (rec (step x z) xs)))))
(prove
  (forall ((p (R T)) (q (R T)) (s (list T)))
    (= (rec (|:+:| p q) s) (rec (|:>:| p q) s))))
