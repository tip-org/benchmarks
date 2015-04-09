; Regular expressions
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((A (X) (Y))))
(declare-datatypes
  ()
  ((R
     (Nil) (Eps) (Atom (Atom_ A)) (Plus (Plus_ R) (Plus_2 R))
     (Seq (Seq_ R) (Seq_2 R)) (Star (Star_ R)))))
(define-funs-rec
  ((seq ((x5 R) (x6 R)) R))
  ((match x5
     (case
       default
       (match x6
         (case
           default
           (match x5
             (case
               default
               (match x6
                 (case default (Seq x5 x6))
                 (case Eps x5)))
             (case Eps x6)))
         (case Nil x6)))
     (case Nil x5))))
(define-funs-rec
  ((plus ((x13 R) (x14 R)) R))
  ((match x13
     (case
       default
       (match x14
         (case default (Plus x13 x14))
         (case Nil x13)))
     (case Nil x14))))
(define-funs-rec
  ((or2 ((x21 bool) (x22 bool)) bool)) ((ite x21 x21 x22)))
(define-funs-rec
  ((eqA ((x15 A) (x16 A)) bool))
  ((match x15
     (case X false)
     (case
       Y
       (match x16
         (case X false)
         (case Y true))))))
(define-funs-rec
  ((par
     (a4 b2)
     (consfst
        ((x19 a4) (x20 (list (Pair (list a4) b2))))
        (list (Pair (list a4) b2)))))
  ((match x20
     (case nil x20)
     (case
       (cons ds3 ys)
       (match ds3
         (case
           (Pair2 xs3 y)
           (cons
             (Pair2 (cons x19 xs3) y)
             (as (consfst x19 ys) (list (Pair (list a4) b2))))))))))
(define-funs-rec
  ((par
     (a3) (split ((x3 (list a3))) (list (Pair (list a3) (list a3))))))
  ((match x3
     (case
       nil
       (cons (Pair2 x3 x3) (as nil (list (Pair (list a3) (list a3))))))
     (case
       (cons x4 s)
       (cons
         (Pair2 (as nil (list a3)) x3)
         (consfst x4 (as (split s) (list (Pair (list a3) (list a3))))))))))
(define-funs-rec
  ((and2 ((x23 bool) (x24 bool)) bool)) ((ite x23 x24 x23)))
(define-funs-rec
  ((eps ((x18 R)) bool))
  ((match x18
     (case default false)
     (case Eps true)
     (case (Plus p4 q3) (or2 (eps p4) (eps q3)))
     (case (Seq p5 q4) (and2 (eps p5) (eps q4)))
     (case (Star ds2) true))))
(define-funs-rec ((epsR ((x17 R)) R)) ((ite (eps x17) Eps Nil)))
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
  ((recognise ((x10 R) (x11 (list A))) bool))
  ((match x11
     (case nil (eps x10))
     (case (cons x12 xs2) (recognise (step x10 x12) xs2)))))
(define-funs-rec
  ((recognisePair
      ((x7 R) (x8 R) (x9 (list (Pair (list A) (list A))))) bool))
  ((match x9
     (case nil false)
     (case
       (cons ds xs)
       (match ds
         (case
           (Pair2 s2 s3)
           (or2
             (and2 (recognise x7 s2) (recognise x8 s3))
             (recognisePair x7 x8 xs))))))))
(assert
  (not
    (forall
      ((p6 R) (q5 R) (s4 (list A)))
      (= (recognise (Seq p6 q5) s4) (recognisePair p6 q5 (split s4))))))
(check-sat)
