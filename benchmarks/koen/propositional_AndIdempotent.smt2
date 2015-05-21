; Propositional solver
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes ()
  ((Form (& (&_0 Form) (&_1 Form))
     (Not (Not_0 Form)) (Var (Var_0 Int)))))
(define-funs-rec ((or2 ((x Bool) (y Bool)) Bool)) ((ite x true y)))
(define-funs-rec
  ((or3 ((x (list Bool))) Bool))
  ((match x
     (case nil false)
     (case (cons y xs) (or2 y (or3 xs))))))
(define-funs-rec
  ((par (t) (null ((x (list t))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((models4 ((x Int) (y (list (Pair Int Bool)))) (list Bool)))
  ((match y
     (case nil (as nil (list Bool)))
     (case (cons z x2)
       (match z
         (case (Pair2 y2 x3)
           (ite x3 (models4 x x2) (cons (= x y2) (models4 x x2)))))))))
(define-funs-rec
  ((models3 ((x Int) (y (list (Pair Int Bool)))) (list Bool)))
  ((match y
     (case nil (as nil (list Bool)))
     (case (cons z x2)
       (match z
         (case (Pair2 y2 x3)
           (ite x3 (cons (= x y2) (models3 x x2)) (models3 x x2))))))))
(define-funs-rec
  ((par (a b) (fst ((x (Pair a b))) a)))
  ((match x (case (Pair2 y z) y))))
(define-funs-rec
  ((par (t) (filter ((p (=> t Bool)) (x (list t))) (list t))))
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
  ((models
      ((x Form) (y (list (Pair Int Bool))))
      (list (list (Pair Int Bool))))
   (models2
      ((q Form) (x (list (list (Pair Int Bool)))))
      (list (list (Pair Int Bool))))
   (models5
      ((q Form) (x (list (list (Pair Int Bool))))
       (y (list (list (Pair Int Bool)))))
      (list (list (Pair Int Bool)))))
  ((match x
     (case (& p q) (models2 q (models p y)))
     (case (Not z)
       (match z
         (case (& p2 q2)
           (append (models (Not p2) y) (models (& p2 (Not q2)) y)))
         (case (Not p3) (models p3 y))
         (case (Var x2)
           (ite
             (not (or3 (models3 x2 y)))
             (cons
             (cons (Pair2 x2 false)
               (filter
               (lambda ((x3 (Pair Int Bool)))
                 (dot (lambda ((x4 Int)) (distinct x2 x4))
                   (lambda ((x5 (Pair Int Bool))) (fst x5)) x3))
                 y))
               (as nil (list (list (Pair Int Bool)))))
             (as nil (list (list (Pair Int Bool))))))))
     (case (Var x6)
       (ite
         (not (or3 (models4 x6 y)))
         (cons
         (cons (Pair2 x6 true)
           (filter
           (lambda ((x7 (Pair Int Bool)))
             (dot (lambda ((x8 Int)) (distinct x6 x8))
               (lambda ((x9 (Pair Int Bool))) (fst x9)) x7))
             y))
           (as nil (list (list (Pair Int Bool)))))
         (as nil (list (list (Pair Int Bool)))))))
   (match x
     (case nil x)
     (case (cons y z) (models5 q z (models q y))))
   (match y
     (case nil (models2 q x))
     (case (cons z x2) (cons z (models5 q x x2))))))
(define-funs-rec
  ((valid ((x Form)) Bool))
  ((null (models (Not x) (as nil (list (Pair Int Bool)))))))
(assert-not (forall ((p Form)) (= (valid (& p p)) (valid p))))
(check-sat)
