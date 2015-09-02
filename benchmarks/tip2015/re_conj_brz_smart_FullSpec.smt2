; Regular expressions using Brzozowski derivatives (see the step function)
; The plus and seq functions are smart constructors.
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
             (case (Pair2 as2 bs)
               (cons (Pair2 (cons x as2) bs) (splits2 x x2)))))))))
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
(define-fun
  seq
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
(define-fun
  plus
    ((x R) (y R)) R
    (match x
      (case default
        (match y
          (case default (Plus x y))
          (case Nil x)))
      (case Nil y)))
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
      (case (And p2 q2) (and (eps p2) (eps q2)))
      (case (Seq p3 q3) (and (eps p3) (eps q3)))
      (case (Star y) true)))
(define-fun epsR ((x R)) R (ite (eps x) Eps Nil))
(define-fun-rec
  okay
    ((x R)) Bool
    (match x
      (case default true)
      (case (Plus p q) (and (okay p) (okay q)))
      (case (Seq p2 q2) (and (okay p2) (okay q2)))
      (case (Star p3) (and (okay p3) (not (eps p3))))))
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
     (case (And p2 q2) (and (reck p2 y) (reck q2 y)))
     (case (Seq p3 q3) (or2 (reck2 p3 q3 (splits y))))
     (case (Star p4)
       (match y
         (case nil true)
         (case (cons x6 x7) (and (not (eps p4)) (reck (Seq p4 x) y))))))
   (match x
     (case nil (as nil (list Bool)))
     (case (cons y z)
       (match y
         (case (Pair2 l r)
           (cons (and (reck p l) (reck q r)) (reck2 p q z))))))))
(define-fun
  conj
    ((x R) (y R)) R
    (match x
      (case default
        (match y
          (case default (And x y))
          (case Nil Nil)))
      (case Nil Nil)))
(define-fun-rec
  step
    ((x R) (y A)) R
    (match x
      (case default Nil)
      (case (Atom a) (ite (eqA a y) Eps Nil))
      (case (Plus p q) (plus (step p y) (step q y)))
      (case (And p2 q2) (conj (step p2 y) (step q2 y)))
      (case (Seq p3 q3)
        (plus (seq (step p3 y) q3) (seq (epsR p3) (step q3 y))))
      (case (Star p4) (seq (step p4 y) x))))
(define-fun-rec
  recognise
    ((x R) (y (list A))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (recognise (step x z) xs))))
(assert-not
  (forall ((p R) (s (list A)))
    (=> (okay p) (= (recognise p s) (reck p s)))))
(check-sat)
