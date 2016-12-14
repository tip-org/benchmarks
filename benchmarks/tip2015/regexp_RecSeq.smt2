; Regular expressions using Brzozowski derivatives (see the step function)
; The plus and seq functions are smart constructors.
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes ()
  ((R (Nil)
     (Eps) (Atom (proj1-Atom A)) (Plus (proj1-Plus R) (proj2-Plus R))
     (Seq (proj1-Seq R) (proj2-Seq R)) (Star (proj1-Star R)))))
(define-fun-rec
  (par (a)
    (split
       ((x a) (y (list (pair (list a) (list a)))))
       (list (pair (list a) (list a)))
       (match y
         (case nil (as nil (list (pair (list a) (list a)))))
         (case (cons z x2)
           (match z
             (case (pair2 xs ys)
               (cons (pair2 (cons x xs) ys) (split x x2)))))))))
(define-fun-rec
  (par (a)
    (split2
       ((x (list a))) (list (pair (list a) (list a)))
       (match x
         (case nil
           (cons (pair2 (as nil (list a)) (as nil (list a)))
             (as nil (list (pair (list a) (list a))))))
         (case (cons y s)
           (cons (pair2 (as nil (list a)) x) (split y (split2 s))))))))
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
      (case (Seq r q2) (and (eps r) (eps q2)))
      (case (Star y) true)))
(define-fun epsR ((x R)) R (ite (eps x) Eps Nil))
(define-fun-rec
  step
    ((x R) (y A)) R
    (match x
      (case default Nil)
      (case (Atom a) (ite (eqA a y) Eps Nil))
      (case (Plus p q) (plus (step p y) (step q y)))
      (case (Seq r q2)
        (plus (seq (step r y) q2) (seq (epsR r) (step q2 y))))
      (case (Star p2) (seq (step p2 y) x))))
(define-fun-rec
  recognise
    ((x R) (y (list A))) Bool
    (match y
      (case nil (eps x))
      (case (cons z xs) (recognise (step x z) xs))))
(define-fun-rec
  formula
    ((p R) (q R) (x (list (pair (list A) (list A))))) (list Bool)
    (match x
      (case nil (as nil (list Bool)))
      (case (cons y z)
        (match y
          (case (pair2 s1 s2)
            (cons (and (recognise p s1) (recognise q s2)) (formula p q z)))))))
(assert-not
  (forall ((p R) (q R) (s (list A)))
    (= (recognise (Seq p q) s) (or2 (formula p q (split2 s))))))
(check-sat)
