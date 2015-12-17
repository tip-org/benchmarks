; Regular expressions specification
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes ()
  ((R (Nil)
     (Eps) (Atom (Atom_0 A)) (Plus (Plus_0 R) (Plus_1 R))
     (And (And_0 R) (And_1 R)) (Seq (Seq_0 R) (Seq_1 R))
     (Star (Star_0 R)))))
(define-fun-rec
  (par (a)
    (splits2
       ((x a) (y (list (Pair (list a) (list a)))))
       (list (Pair (list a) (list a)))
       (match y
         (case nil (as nil (list (Pair (list a) (list a)))))
         (case (cons z x2)
           (match z
             (case (Pair2 bs cs)
               (cons (Pair2 (cons x bs) cs) (splits2 x x2)))))))))
(define-fun-rec
  (par (a)
    (splits
       ((x (list a))) (list (Pair (list a) (list a)))
       (match x
         (case nil
           (cons (Pair2 (as nil (list a)) (as nil (list a)))
             (as nil (list (Pair (list a) (list a))))))
         (case (cons y xs)
           (cons (Pair2 (as nil (list a)) x) (splits2 y (splits xs))))))))
(define-fun-rec
  or2
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
(define-fun
  eqA
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
  eps
    ((x R)) Bool
    (match x
      (case default false)
      (case Eps true)
      (case (Plus p q) (or (eps p) (eps q)))
      (case (And r q2) (and (eps r) (eps q2)))
      (case (Seq p2 q3) (and (eps p2) (eps q3)))
      (case (Star y) true)))
(define-funs-rec
  ((reck ((x R) (y (list A))) Bool)
   (reck2
      ((p R) (q R) (x (list (Pair (list A) (list A))))) (list Bool)))
  ((match x
     (case Nil false)
     (case Eps
       (match y
         (case nil true)
         (case (cons z x2) false)))
     (case (Atom b)
       (match y
         (case nil false)
         (case (cons c x3)
           (match x3
             (case nil (eqA b c))
             (case (cons x4 x5) false)))))
     (case (Plus p q) (or (reck p y) (reck q y)))
     (case (And r q2) (and (reck r y) (reck q2 y)))
     (case (Seq p2 q3) (or2 (reck2 p2 q3 (splits y))))
     (case (Star p3)
       (match y
         (case nil true)
         (case (cons x6 x7) (and (not (eps p3)) (reck (Seq p3 x) y))))))
   (match x
     (case nil (as nil (list Bool)))
     (case (cons y z)
       (match y
         (case (Pair2 l r)
           (cons (and (reck p l) (reck q r)) (reck2 p q z))))))))
(assert-not
  (forall ((p R))
    (not (reck p (cons X (cons Y (cons Y (as nil (list A)))))))))
(check-sat)
