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
  ((or2 ((x17 bool) (x18 bool)) bool)) ((ite x17 x17 x18)))
(define-funs-rec
  ((eqA ((x13 A) (x14 A)) bool))
  ((match x13
     (case X false)
     (case
       Y
       (match x14
         (case X false)
         (case Y true))))))
(define-funs-rec
  ((and2 ((x19 bool) (x20 bool)) bool)) ((ite x19 x20 x19)))
(define-funs-rec
  ((eps ((x16 R)) bool))
  ((match x16
     (case default false)
     (case Eps true)
     (case (Plus p4 q3) (or2 (eps p4) (eps q3)))
     (case (Seq p5 q4) (and2 (eps p5) (eps q4)))
     (case (Star ds) true))))
(define-funs-rec ((epsR ((x15 R)) R)) ((ite (eps x15) Eps Nil)))
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
(define-funs-rec
  ((eqList ((x10 (list A)) (x11 (list A))) bool))
  ((match x10
     (case
       nil
       (match x11
         (case nil true)
         (case (cons d d2) false)))
     (case
       (cons x12 xs2)
       (match x11
         (case nil false)
         (case (cons y ys) (and2 (eqA x12 y) (eqList xs2 ys))))))))
(assert-not
  (forall
    ((a3 A) (s (list A)))
    (=
      (recognise (Atom a3) s) (eqList s (cons a3 (as nil (list A)))))))
(check-sat)
