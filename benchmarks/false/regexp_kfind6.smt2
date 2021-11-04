(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
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
  splits
  (par (a)
    (((x a) (y (list (pair (list a) (list a)))))
     (list (pair (list a) (list a)))))
  (match y
    ((nil (_ nil (pair (list a) (list a))))
     ((cons z x2)
      (match z
        (((pair2 bs cs) (cons (pair2 (cons x bs) cs) (splits x x2)))))))))
(define-fun-rec
  splits2
  (par (a) (((x (list a))) (list (pair (list a) (list a)))))
  (match x
    ((nil
      (cons (pair2 (_ nil a) (_ nil a))
        (_ nil (pair (list a) (list a)))))
     ((cons y xs) (cons (pair2 (_ nil a) x) (splits y (splits2 xs)))))))
(define-fun-rec
  or2
  ((x (list Bool))) Bool
  (match x
    ((nil false)
     ((cons y xs) (or y (or2 xs))))))
(define-fun-rec
  eps
  (par (a) (((x (R a))) Bool))
  (match x
    ((Eps true)
     ((|:+:| p q) (or (eps p) (eps q)))
     ((|:>:| r q2) (and (eps r) (eps q2)))
     ((Star y) true)
     (_ false))))
(define-fun-rec
  step
  ((x (R T)) (y T)) (R T)
  (match x
    (((Atom b) (ite (= b y) (_ Eps T) (_ Nil T)))
     ((|:+:| p q) (|:+:| (step p y) (step q y)))
     ((|:>:| r q2)
      (ite
        (eps r) (|:+:| (|:>:| (step r y) q2) (step q2 y))
        (|:+:| (|:>:| (step r y) q2) (_ Nil T))))
     ((Star p2) (|:>:| (step p2 y) x))
     (_ (_ Nil T)))))
(define-fun-rec
  rec
  ((x (R T)) (y (list T))) Bool
  (match y
    ((nil (eps x))
     ((cons z xs) (rec (step x z) xs)))))
(define-funs-rec
  ((reck2
    ((x (R T)) (y (list T))) Bool)
   (reck
    ((p (R T)) (q (R T)) (x (list (pair (list T) (list T)))))
    (list Bool)))
  ((match x
     ((Nil false)
      (Eps
       (match y
         ((nil true)
          ((cons z x2) false))))
      ((Atom c)
       (match y
         ((nil false)
          ((cons b2 x3)
           (match x3
             ((nil (= c b2))
              ((cons x4 x5) false)))))))
      ((|:+:| p q) (or (reck2 p y) (reck2 q y)))
      ((|:>:| r q2) (or2 (reck r q2 (splits2 y))))
      ((Star p2)
       (match y
         ((nil true)
          ((cons x6 x7) (ite (not (eps p2)) (rec (|:>:| p2 x) y) false)))))))
   (match x
     ((nil (_ nil Bool))
      ((cons y z)
       (match y
         (((pair2 l r)
           (cons (and (reck2 p l) (rec q r)) (reck p q z))))))))))
(prove
  (forall ((p (R T)))
    (not
      (reck2 p (cons A (cons B (cons A (cons B (cons B (_ nil T))))))))))
