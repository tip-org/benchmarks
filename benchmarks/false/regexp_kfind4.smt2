(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
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
    (splits
       ((x a) (y (list (pair (list a) (list a)))))
       (list (pair (list a) (list a)))
       (match y
         (case nil (_ nil (pair (list a) (list a))))
         (case (cons z x2)
           (match z
             (case (pair2 bs cs)
               (cons (pair2 (cons x bs) cs) (splits x x2)))))))))
(define-fun-rec
  (par (a)
    (splits2
       ((x (list a))) (list (pair (list a) (list a)))
       (match x
         (case nil
           (cons (pair2 (_ nil a) (_ nil a))
             (_ nil (pair (list a) (list a)))))
         (case (cons y xs)
           (cons (pair2 (_ nil a) x) (splits y (splits2 xs))))))))
(define-fun-rec
  or2
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
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
(define-funs-rec
  ((reck2 ((x (R T)) (y (list T))) Bool)
   (reck
      ((p (R T)) (q (R T)) (x (list (pair (list T) (list T)))))
      (list Bool)))
  ((match x
     (case Nil false)
     (case Eps
       (match y
         (case nil true)
         (case (cons z x2) false)))
     (case (Atom c)
       (match y
         (case nil false)
         (case (cons b2 x3)
           (match x3
             (case nil (= c b2))
             (case (cons x4 x5) false)))))
     (case (|:+:| p q) (or (reck2 p y) (reck2 q y)))
     (case (|:>:| r q2) (or2 (reck r q2 (splits2 y))))
     (case (Star p2)
       (match y
         (case nil true)
         (case (cons x6 x7)
           (ite (not (eps p2)) (rec (|:>:| p2 x) y) false)))))
   (match x
     (case nil (_ nil Bool))
     (case (cons y z)
       (match y
         (case (pair2 l r)
           (cons (and (reck2 p l) (rec q r)) (reck p q z))))))))
(prove
  (forall ((p (R T)))
    (not (reck2 p (cons A (cons B (cons B (cons A (_ nil T)))))))))
