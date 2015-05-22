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
  ((models3 ((x Int) (y (list (Pair Int Bool)))) (list Bool)))
  ((match y
     (case nil (as nil (list Bool)))
     (case (cons z x2)
       (match z
         (case (Pair2 y2 x3)
           (ite x3 (models3 x x2) (cons (= x y2) (models3 x x2)))))))))
(define-funs-rec
  ((par (a b) (fst ((x (Pair a b))) a)))
  ((match x (case (Pair2 y z) y))))
(define-funs-rec
  ((par (t) (filter ((p (=> t Bool)) (x (list t))) (list t))))
  ((match x
     (case nil (as nil (list t)))
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
  ((and2 ((x Bool) (y Bool)) Bool)) ((ite x y false)))
(define-funs-rec
  ((par (t) (all ((x (=> t Bool)) (y (list t))) Bool)))
  ((match y
     (case nil true)
     (case (cons z xs) (and2 (@ x z) (all x xs))))))
(define-funs-rec
  ((=3 ((x Int) (y (list (Pair Int Bool)))) (list Bool)))
  ((match y
     (case nil (as nil (list Bool)))
     (case (cons z x2)
       (match z
         (case (Pair2 y2 x3)
           (ite x3 (cons (= x y2) (=3 x x2)) (=3 x x2))))))))
(define-funs-rec
  ((models
      ((x Form) (y (list (Pair Int Bool))))
      (list (list (Pair Int Bool))))
   (models2
      ((q Form) (x (list (list (Pair Int Bool)))))
      (list (list (Pair Int Bool))))
   (models4
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
             (not (or3 (=3 x2 y)))
             (cons
             (cons (Pair2 x2 false)
               (filter (lambda ((x3 (Pair Int Bool))) (distinct x2 (fst x3))) y))
               (as nil (list (list (Pair Int Bool)))))
             (as nil (list (list (Pair Int Bool))))))))
     (case (Var x4)
       (ite
         (not (or3 (models3 x4 y)))
         (cons
         (cons (Pair2 x4 true)
           (filter (lambda ((x3 (Pair Int Bool))) (distinct x4 (fst x3))) y))
           (as nil (list (list (Pair Int Bool)))))
         (as nil (list (list (Pair Int Bool)))))))
   (match x
     (case nil (as nil (list (list (Pair Int Bool)))))
     (case (cons y z) (models4 q z (models q y))))
   (match y
     (case nil (models2 q x))
     (case (cons z x2) (cons z (models4 q x x2))))))
(define-funs-rec
  ((=2 ((x (list (Pair Int Bool))) (y Form)) Bool))
  ((match y
     (case (& p q) (and2 (=2 x p) (=2 x q)))
     (case (Not p2) (not (=2 x p2)))
     (case (Var z) (or3 (=3 z x))))))
(assert-not
  (forall ((p Form))
    (all (lambda ((x (list (Pair Int Bool)))) (=2 x p))
      (models p (as nil (list (Pair Int Bool)))))))
(check-sat)
