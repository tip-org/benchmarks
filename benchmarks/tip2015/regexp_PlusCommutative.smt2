; Regular expressions using Brzozowski derivatives (see the step function)
; The plus and seq functions are smart constructors.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
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
         (case Nil y)))
     (case Nil x))))
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
(assert-not
  (forall ((p R) (q R) (s (list A)))
    (= (recognise (Plus p q) s) (recognise (Plus q p) s))))
(check-sat)
