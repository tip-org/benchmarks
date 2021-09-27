(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype T ((A) (B) (C)))
(declare-datatype
  R
  (par (a)
    ((Nil) (Eps) (Atom (proj1-Atom a))
     (|:+:| (|proj1-:+:| (R a)) (|proj2-:+:| (R a)))
     (|:&:| (|proj1-:&:| (R a)) (|proj2-:&:| (R a)))
     (|:>:| (|proj1-:>:| (R a)) (|proj2-:>:| (R a)))
     (Star (proj1-Star (R a))))))
(define-fun
  x.>.
  ((x (R T)) (y (R T))) (R T)
  (match x
    ((Nil (_ Nil T))
     (_
      (match y
        ((Nil (_ Nil T))
         (_
          (match x
            ((Eps y)
             (_
              (match y
                ((Eps x)
                 (_ (|:>:| x y))))))))))))))
(define-fun
  x.+.
  ((x (R T)) (y (R T))) (R T)
  (match x
    ((Nil y)
     (_
      (match y
        ((Nil x)
         (_ (|:+:| x y))))))))
(define-fun
  x.&.
  ((x (R T)) (y (R T))) (R T)
  (match x
    ((Nil (_ Nil T))
     (_
      (match y
        ((Nil (_ Nil T))
         (_ (|:&:| x y))))))))
(define-fun-rec
  eps
  ((x (R T))) Bool
  (match x
    ((Eps true)
     ((|:+:| p q) (or (eps p) (eps q)))
     ((|:&:| r q2) (and (eps r) (eps q2)))
     ((|:>:| p2 q3) (and (eps p2) (eps q3)))
     ((Star y) true)
     (_ false))))
(define-fun-rec
  step
  ((x (R T)) (y T)) (R T)
  (match x
    (((Atom b) (ite (= b y) (_ Eps T) (_ Nil T)))
     ((|:+:| p q) (x.+. (step p y) (step q y)))
     ((|:&:| r q2)
      (let
        ((z (step r y))
         (q1 (step q2 y)))
        (match z
          ((Nil (_ Nil T))
           (_
            (match q1
              ((Nil (_ Nil T))
               (_ (|:&:| z q1)))))))))
     ((|:>:| p2 q3)
      (ite
        (eps p2) (x.+. (x.>. (step p2 y) q3) (step q3 y))
        (x.+. (x.>. (step p2 y) q3) (_ Nil T))))
     ((Star p3) (x.>. (step p3 y) x))
     (_ (_ Nil T)))))
(define-fun-rec
  rec
  ((x (R T)) (y (list T))) Bool
  (match y
    ((nil (eps x))
     ((cons z xs) (rec (step x z) xs)))))
(prove
  (forall ((p (R T)) (s (list T)))
    (=> (not (eps p)) (not (rec (x.&. p (x.>. p p)) s)))))
