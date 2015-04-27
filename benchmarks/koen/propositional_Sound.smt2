(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes ()
  ((Form (& (&_0 Form) (&_1 Form))
     (Not (Not_0 Form)) (Var (Var_0 int)))))
(define-funs-rec
  ((par (t) (z ((p (=> t bool)) (x4 (list t))) (list t))))
  ((match x4
     (case nil x4)
     (case (cons x5 x6) (ite (@ p x5) (cons x5 (z p x6)) (z p x6))))))
(define-funs-rec
  ((x2 ((x4 int) (x5 (list (Pair2 int bool)))) (list bool)))
  ((match x5
     (case nil (as nil (list bool)))
     (case (cons x6 x7)
       (match x6
         (case (Pair y2 x8)
           (ite x8 (x2 x4 x7) (cons (= x4 y2) (x2 x4 x7)))))))))
(define-funs-rec
  ((x ((x4 int) (x5 (list (Pair2 int bool)))) (list bool)))
  ((match x5
     (case nil (as nil (list bool)))
     (case (cons x6 x7)
       (match x6
         (case (Pair y2 x8)
           (ite x8 (cons (= x4 y2) (x x4 x7)) (x x4 x7))))))))
(define-funs-rec
  ((or2 ((x4 bool) (x5 bool)) bool)) ((ite x4 true x5)))
(define-funs-rec
  ((or3 ((x4 (list bool))) bool))
  ((match x4
     (case nil false)
     (case (cons x5 xs) (or2 x5 (or3 xs))))))
(define-funs-rec
  ((par (a b) (fst ((x4 (Pair2 a b))) a)))
  ((match x4 (case (Pair x5 x6) x5))))
(define-funs-rec
  ((par (b c a) (dot ((x4 (=> b c)) (x5 (=> a b)) (x6 a)) c)))
  ((@ x4 (@ x5 x6))))
(define-funs-rec
  ((par (a) (append ((x4 (list a)) (x5 (list a))) (list a))))
  ((match x4
     (case nil x5)
     (case (cons x6 xs) (cons x6 (append xs x5))))))
(define-funs-rec
  ((models
      ((x4 Form) (x5 (list (Pair2 int bool))))
      (list (list (Pair2 int bool))))
   (y ((q Form) (x4 (list (list (Pair2 int bool)))))
      (list (list (Pair2 int bool))))
   (x3
      ((q Form) (x4 (list (list (Pair2 int bool))))
       (x5 (list (list (Pair2 int bool)))))
      (list (list (Pair2 int bool)))))
  ((match x4
     (case (& p q) (y q (models p x5)))
     (case (Not x6)
       (match x6
         (case (& p2 q2)
           (append (models (Not p2) x5) (models (& p2 (Not q2)) x5)))
         (case (Not p3) (models p3 x5))
         (case (Var x7)
           (ite
             (not (or3 (x x7 x5)))
             (cons
             (cons (Pair x7 false)
               (z
               (lambda ((x8 (Pair2 int bool)))
                 (dot (lambda ((x9 int)) (distinct x7 x9))
                   (lambda ((x10 (Pair2 int bool))) (fst x10)) x8))
                 x5))
               (as nil (list (list (Pair2 int bool)))))
             (as nil (list (list (Pair2 int bool))))))))
     (case (Var x11)
       (ite
         (not (or3 (x2 x11 x5)))
         (cons
         (cons (Pair x11 true)
           (z
           (lambda ((x12 (Pair2 int bool)))
             (dot (lambda ((x13 int)) (distinct x11 x13))
               (lambda ((x14 (Pair2 int bool))) (fst x14)) x12))
             x5))
           (as nil (list (list (Pair2 int bool)))))
         (as nil (list (list (Pair2 int bool)))))))
   (match x4
     (case nil x4)
     (case (cons x5 x6) (x3 q x6 (models q x5))))
   (match x5
     (case nil (y q x4))
     (case (cons x6 x7) (cons x6 (x3 q x4 x7))))))
(define-funs-rec
  ((and2 ((x4 bool) (x5 bool)) bool)) ((ite x4 x5 false)))
(define-funs-rec
  ((par (t) (all ((x4 (=> t bool)) (x5 (list t))) bool)))
  ((match x5
     (case nil true)
     (case (cons x6 xs) (and2 (@ x4 x6) (all x4 xs))))))
(define-funs-rec
  ((=2 ((x4 (list (Pair2 int bool))) (x5 Form)) bool))
  ((match x5
     (case (& p q) (and2 (=2 x4 p) (=2 x4 q)))
     (case (Not p2) (not (=2 x4 p2)))
     (case (Var x6) (or3 (x x6 x4))))))
(assert-not
  (forall ((p Form))
    (all (lambda ((x4 (list (Pair2 int bool)))) (=2 x4 p))
      (models p (as nil (list (Pair2 int bool)))))))
(check-sat)
