; Propositional solver
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes ()
  ((Form (& (&_0 Form) (&_1 Form))
     (Not (Not_0 Form)) (Var (Var_0 int)))))
(define-funs-rec ((or2 ((x bool) (y bool)) bool)) ((ite x true y)))
(define-funs-rec
  ((or3 ((x (list bool))) bool))
  ((match x
     (case nil false)
     (case (cons y xs) (or2 y (or3 xs))))))
(define-funs-rec
  ((models3 ((x int) (y (list (Pair2 int bool)))) (list bool)))
  ((match y
     (case nil (as nil (list bool)))
     (case (cons z x2)
       (match z
         (case (Pair y2 x3)
           (ite x3 (models3 x x2) (cons (= x y2) (models3 x x2)))))))))
(define-funs-rec
  ((par (a b) (fst ((x (Pair2 a b))) a)))
  ((match x (case (Pair y z) y))))
(define-funs-rec
  ((par (t) (filter ((p (=> t bool)) (x (list t))) (list t))))
  ((match x
     (case nil x)
     (case (cons y z)
       (ite (@ p y) (cons y (filter p z)) (filter p z))))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((par (t) (all ((x (=> t bool)) (y (list t))) bool)))
  ((match y
     (case nil true)
     (case (cons z xs) (and2 (@ x z) (all x xs))))))
(define-funs-rec
  ((=3 ((x int) (y (list (Pair2 int bool)))) (list bool)))
  ((match y
     (case nil (as nil (list bool)))
     (case (cons z x2)
       (match z
         (case (Pair y2 x3)
           (ite x3 (cons (= x y2) (=3 x x2)) (=3 x x2))))))))
(define-funs-rec
  ((models
      ((x Form) (y (list (Pair2 int bool))))
      (list (list (Pair2 int bool))))
   (models2
      ((q Form) (x (list (list (Pair2 int bool)))))
      (list (list (Pair2 int bool))))
   (models4
      ((q Form) (x (list (list (Pair2 int bool))))
       (y (list (list (Pair2 int bool)))))
      (list (list (Pair2 int bool)))))
  ((match x
     (case (& p q) (models2 q (models p y)))
     (case (Not z)
       (match z
         (case (& p2 q2)
           (append (models (Not p2) y) (models (& p2 (Not q2)) y)))
         (case (Not p3) (models p3 y))
         (case (Var x2)
           (ite
             (not (or3 (=3 x2 y)))
             (cons
             (cons (Pair x2 false)
               (filter
               (lambda ((x3 (Pair2 int bool)))
                 (dot (lambda ((x4 int)) (distinct x2 x4))
                   (lambda ((x5 (Pair2 int bool))) (fst x5)) x3))
                 y))
               (as nil (list (list (Pair2 int bool)))))
             (as nil (list (list (Pair2 int bool))))))))
     (case (Var x6)
       (ite
         (not (or3 (models3 x6 y)))
         (cons
         (cons (Pair x6 true)
           (filter
           (lambda ((x7 (Pair2 int bool)))
             (dot (lambda ((x8 int)) (distinct x6 x8))
               (lambda ((x9 (Pair2 int bool))) (fst x9)) x7))
             y))
           (as nil (list (list (Pair2 int bool)))))
         (as nil (list (list (Pair2 int bool)))))))
   (match x
     (case nil x)
     (case (cons y z) (models4 q z (models q y))))
   (match y
     (case nil (models2 q x))
     (case (cons z x2) (cons z (models4 q x x2))))))
(define-funs-rec
  ((=2 ((x (list (Pair2 int bool))) (y Form)) bool))
  ((match y
     (case (& p q) (and2 (=2 x p) (=2 x q)))
     (case (Not p2) (not (=2 x p2)))
     (case (Var z) (or3 (=3 z x))))))
(assert-not
  (forall ((p Form))
    (all (lambda ((x (list (Pair2 int bool)))) (=2 x p))
      (models p (as nil (list (Pair2 int bool)))))))
(check-sat)
