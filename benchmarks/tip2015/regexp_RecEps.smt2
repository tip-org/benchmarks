; Regular expressions
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes
  ()
  ((R
     (Nil) (Eps) (Atom (Atom_ A)) (Plus (Plus_ R) (Plus_2 R))
     (Seq (Seq_ R) (Seq_2 R)) (Star (Star_ R)))))
(define-funs-rec
  ((seq ((x3 R) (x4 R)) R))
  ((match x3
     (case
       default
       (match x4
         (case
           default
           (match x3
             (case
               default
               (match x4
                 (case default (Seq x3 x4))
                 (case Eps x3)))
             (case Eps x4)))
         (case Nil x4)))
     (case Nil x3))))
(define-funs-rec
  ((plus ((x8 R) (x9 R)) R))
  ((match x8
     (case
       default
       (match x9
         (case default (Plus x8 x9))
         (case Nil x8)))
     (case Nil x9))))
(define-funs-rec
  ((or2 ((x14 bool) (x15 bool)) bool)) ((ite x14 x14 x15)))
(define-funs-rec
  ((par (a3) (null ((x18 (list a3))) bool)))
  ((match x18
     (case nil true)
     (case (cons ds2 ds3) false))))
(define-funs-rec
  ((eqA ((x10 A) (x11 A)) bool))
  ((match x10
     (case X false)
     (case
       Y
       (match x11
         (case X false)
         (case Y true))))))
(define-funs-rec
  ((and2 ((x16 bool) (x17 bool)) bool)) ((ite x16 x17 x16)))
(define-funs-rec
  ((eps ((x13 R)) bool))
  ((match x13
     (case default false)
     (case Eps true)
     (case (Plus p4 q3) (or2 (eps p4) (eps q3)))
     (case (Seq p5 q4) (and2 (eps p5) (eps q4)))
     (case (Star ds) true))))
(define-funs-rec ((epsR ((x12 R)) R)) ((ite (eps x12) Eps Nil)))
(define-funs-rec
  ((step ((x R) (x2 A)) R))
  ((match x
     (case default Nil)
     (case (Atom a2) (ite (eqA a2 x2) Eps Nil))
     (case (Plus p q) (plus (step p x2) (step q x2)))
     (case
       (Seq p2 q2)
       (plus (seq (step p2 x2) q2) (seq (epsR p2) (step q2 x2))))
     (case (Star p3) (seq (step p3 x2) x)))))
(define-funs-rec
  ((recognise ((x5 R) (x6 (list A))) bool))
  ((match x6
     (case nil (eps x5))
     (case (cons x7 xs) (recognise (step x5 x7) xs)))))
(assert
  (not (forall ((s (list A))) (= (recognise Eps s) (null s)))))
(check-sat)
