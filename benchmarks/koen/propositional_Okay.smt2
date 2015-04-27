(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes ()
  ((Form (& (&_0 Form) (&_1 Form))
     (Not (Not_0 Form)) (Var (Var_0 int)))))
(define-funs-rec
  ((z ((x5 int) (x6 (list (Pair2 int bool)))) (list bool)))
  ((match x6
     (case nil (as nil (list bool)))
     (case (cons x7 x8)
       (match x7
         (case (Pair y2 x9)
           (ite x9 (cons (= x5 y2) (z x5 x8)) (z x5 x8))))))))
(define-funs-rec
  ((x3 ((x5 int) (x6 (list (Pair2 int bool)))) (list bool)))
  ((match x6
     (case nil (as nil (list bool)))
     (case (cons x7 x8)
       (match x7
         (case (Pair y2 x9)
           (ite x9 (x3 x5 x8) (cons (= x5 y2) (x3 x5 x8)))))))))
(define-funs-rec
  ((par (t) (x2 ((p (=> t bool)) (x5 (list t))) (list t))))
  ((match x5
     (case nil x5)
     (case (cons x6 x7) (ite (@ p x6) (cons x6 (x2 p x7)) (x2 p x7))))))
(define-funs-rec
  ((par (t t2) (x ((f (=> t2 t)) (x5 (list t2))) (list t))))
  ((match x5
     (case nil (as nil (list t)))
     (case (cons x6 x7) (cons (@ f x6) (x f x7))))))
(define-funs-rec
  ((or2 ((x5 bool) (x6 bool)) bool)) ((ite x5 true x6)))
(define-funs-rec
  ((or3 ((x5 (list bool))) bool))
  ((match x5
     (case nil false)
     (case (cons x6 xs) (or2 x6 (or3 xs))))))
(define-funs-rec
  ((par (a b) (fst ((x5 (Pair2 a b))) a)))
  ((match x5 (case (Pair x6 x7) x6))))
(define-funs-rec
  ((elem ((x5 int) (x6 (list int))) bool))
  ((match x6
     (case nil false)
     (case (cons y2 ys) (or2 (= x5 y2) (elem x5 ys))))))
(define-funs-rec
  ((par (b c a) (dot ((x5 (=> b c)) (x6 (=> a b)) (x7 a)) c)))
  ((@ x5 (@ x6 x7))))
(define-funs-rec
  ((par (a) (append ((x5 (list a)) (x6 (list a))) (list a))))
  ((match x5
     (case nil x6)
     (case (cons x7 xs) (cons x7 (append xs x6))))))
(define-funs-rec
  ((models
      ((x5 Form) (x6 (list (Pair2 int bool))))
      (list (list (Pair2 int bool))))
   (y ((q Form) (x5 (list (list (Pair2 int bool)))))
      (list (list (Pair2 int bool))))
   (x4
      ((q Form) (x5 (list (list (Pair2 int bool))))
       (x6 (list (list (Pair2 int bool)))))
      (list (list (Pair2 int bool)))))
  ((match x5
     (case (& p q) (y q (models p x6)))
     (case (Not x7)
       (match x7
         (case (& p2 q2)
           (append (models (Not p2) x6) (models (& p2 (Not q2)) x6)))
         (case (Not p3) (models p3 x6))
         (case (Var x8)
           (ite
             (not (or3 (z x8 x6)))
             (cons
             (cons (Pair x8 false)
               (x2
               (lambda ((x9 (Pair2 int bool)))
                 (dot (lambda ((x10 int)) (distinct x8 x10))
                   (lambda ((x11 (Pair2 int bool))) (fst x11)) x9))
                 x6))
               (as nil (list (list (Pair2 int bool)))))
             (as nil (list (list (Pair2 int bool))))))))
     (case (Var x12)
       (ite
         (not (or3 (x3 x12 x6)))
         (cons
         (cons (Pair x12 true)
           (x2
           (lambda ((x13 (Pair2 int bool)))
             (dot (lambda ((x14 int)) (distinct x12 x14))
               (lambda ((x15 (Pair2 int bool))) (fst x15)) x13))
             x6))
           (as nil (list (list (Pair2 int bool)))))
         (as nil (list (list (Pair2 int bool)))))))
   (match x5
     (case nil x5)
     (case (cons x6 x7) (x4 q x7 (models q x6))))
   (match x6
     (case nil (y q x5))
     (case (cons x7 x8) (cons x7 (x4 q x5 x8))))))
(define-funs-rec
  ((and2 ((x5 bool) (x6 bool)) bool)) ((ite x5 x6 false)))
(define-funs-rec
  ((okay ((x5 (list (Pair2 int bool)))) bool))
  ((match x5
     (case nil true)
     (case (cons x6 m)
       (match x6
         (case (Pair x7 c)
           (and2
           (not (elem x7 (x (lambda ((x8 (Pair2 int bool))) (fst x8)) m)))
             (okay m))))))))
(define-funs-rec
  ((par (t) (all ((x5 (=> t bool)) (x6 (list t))) bool)))
  ((match x6
     (case nil true)
     (case (cons x7 xs) (and2 (@ x5 x7) (all x5 xs))))))
(assert-not
  (forall ((p Form))
    (all (lambda ((x5 (list (Pair2 int bool)))) (okay x5))
      (models p (as nil (list (Pair2 int bool)))))))
(check-sat)
