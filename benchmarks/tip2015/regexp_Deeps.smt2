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
(define-funs-rec
  ((eqA ((x A) (y A)) Bool))
  ((match x
     (case X
       (match y
         (case X true)
         (case Y false)))
     (case Y
       (match y
         (case X false)
         (case Y true))))))
(define-funs-rec
  ((eps ((x R)) Bool))
  ((match x
     (case default false)
     (case Eps true)
     (case (Plus p q) (or (eps p) (eps q)))
     (case (Seq p2 q2) (and (eps p2) (eps q2)))
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
  ((deeps ((x R)) R))
  ((match x
     (case Nil Nil)
     (case Eps Nil)
     (case (Atom a) x)
     (case (Plus p q) (Plus (deeps p) (deeps q)))
     (case (Seq p2 q2)
       (ite (and (eps p2) (eps q2)) (Plus (deeps p2) (deeps q2)) x))
     (case (Star p3) (deeps p3)))))
(assert-not
  (forall ((p R) (s (list A)))
    (= (recognise (Star p) s) (recognise (Star (deeps p)) s))))
(check-sat)
