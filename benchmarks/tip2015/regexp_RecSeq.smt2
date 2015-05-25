; Regular expressions using Brzozowski derivatives (see the step function)
; The plus and seq functions are smart constructors.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes ()
  ((R (Nil)
     (Eps) (Atom (Atom_0 A)) (Plus (Plus_0 R) (Plus_1 R))
     (Seq (Seq_0 R) (Seq_1 R)) (Star (Star_0 R)))))
(define-funs-rec
  ((seq ((x R) (y R)) R))
  ((match x
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
     (case Nil Nil))))
(define-funs-rec
  ((plus ((x R) (y R)) R))
  ((match x
     (case default
       (match y
         (case default (Plus x y))
         (case Nil x)))
     (case Nil y))))
(define-funs-rec ((or2 ((x Bool) (y Bool)) Bool)) ((ite x true y)))
(define-funs-rec
  ((eqA ((x A) (y A)) Bool))
  ((match x
     (case X false)
     (case Y
       (match y
         (case X false)
         (case Y true))))))
(define-funs-rec
  ((par (a b)
     (consfst
        ((x a) (y (list (Pair (list a) b)))) (list (Pair (list a) b)))))
  ((match y
     (case nil (as nil (list (Pair (list a) b))))
     (case (cons z ys)
       (match z
         (case (Pair2 xs y2)
           (cons (Pair2 (cons x xs) y2) (consfst x ys))))))))
(define-funs-rec
  ((par (a) (split ((x (list a))) (list (Pair (list a) (list a))))))
  ((match x
     (case nil
       (cons (Pair2 (as nil (list a)) (as nil (list a)))
         (as nil (list (Pair (list a) (list a))))))
     (case (cons y s)
       (cons (Pair2 (as nil (list a)) x) (consfst y (split s)))))))
(define-funs-rec
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((eps ((x R)) Bool))
  ((match x
     (case default false)
     (case Eps true)
     (case (Plus p q) (or2 (eps p) (eps q)))
     (case (Seq p2 q2) (and2 (eps p2) (eps q2)))
     (case (Star y) true))))
(define-funs-rec ((epsR ((x R)) R)) ((ite (eps x) Eps Nil)))
(define-funs-rec
  ((step ((x R) (y A)) R))
  ((match x
     (case default Nil)
     (case (Atom a) (ite (eqA a y) Eps Nil))
     (case (Plus p q) (plus (step p y) (step q y)))
     (case (Seq p2 q2)
       (plus (seq (step p2 y) q2) (seq (epsR p2) (step q2 y))))
     (case (Star p3) (seq (step p3 y) x)))))
(define-funs-rec
  ((recognise ((x R) (y (list A))) Bool))
  ((match y
     (case nil (eps x))
     (case (cons z xs) (recognise (step x z) xs)))))
(define-funs-rec
  ((recognisePair
      ((x R) (y R) (z (list (Pair (list A) (list A))))) Bool))
  ((match z
     (case nil false)
     (case (cons x2 xs)
       (match x2
         (case (Pair2 s1 s2)
           (or2 (and2 (recognise x s1) (recognise y s2))
             (recognisePair x y xs))))))))
(assert-not
  (forall ((p R) (q R) (s (list A)))
    (= (recognise (Seq p q) s) (recognisePair p q (split s)))))
(check-sat)
