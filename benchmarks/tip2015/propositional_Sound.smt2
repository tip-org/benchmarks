; Propositional solver
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Form (& (proj1-& Form) (proj2-& Form))
     (Not (proj1-Not Form)) (Var (proj1-Var Int)))))
(define-fun-rec
  or2
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
(define-fun-rec
  models7
    ((x Int) (y (list (pair Int Bool)))) (list (pair Int Bool))
    (match y
      (case nil (as nil (list (pair Int Bool))))
      (case (cons z xs)
        (ite
          (distinct x (match z (case (pair2 x2 y2) x2)))
          (cons z (models7 x xs)) (models7 x xs)))))
(define-fun-rec
  models6
    ((x Int) (y (list (pair Int Bool)))) (list Bool)
    (match y
      (case nil (as nil (list Bool)))
      (case (cons z x2)
        (match z
          (case (pair2 y2 x3)
            (ite x3 (models6 x x2) (cons (= x y2) (models6 x x2))))))))
(define-fun-rec
  models5
    ((x Int) (y (list (pair Int Bool)))) (list (pair Int Bool))
    (match y
      (case nil (as nil (list (pair Int Bool))))
      (case (cons z xs)
        (ite
          (distinct x (match z (case (pair2 x2 y2) x2)))
          (cons z (models5 x xs)) (models5 x xs)))))
(define-fun-rec
  models4
    ((x Int) (y (list (pair Int Bool)))) (list Bool)
    (match y
      (case nil (as nil (list Bool)))
      (case (cons z x2)
        (match z
          (case (pair2 y2 x3)
            (ite x3 (cons (= x y2) (models4 x x2)) (models4 x x2)))))))
(define-fun-rec
  =2
    ((x Int) (y (list (pair Int Bool)))) (list Bool)
    (match y
      (case nil (as nil (list Bool)))
      (case (cons z x2)
        (match z
          (case (pair2 y2 x3)
            (ite x3 (cons (= x y2) (=2 x x2)) (=2 x x2)))))))
(define-fun-rec
  =3
    ((x (list (pair Int Bool))) (y Form)) Bool
    (match y
      (case (& p q) (and (=3 x p) (=3 x q)))
      (case (Not r) (not (=3 x r)))
      (case (Var z) (or2 (=2 z x)))))
(define-fun-rec
  formula
    ((p Form) (x (list (list (pair Int Bool))))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (=3 y p) (formula p xs)))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((models3
      ((x Form) (y (list (pair Int Bool))))
      (list (list (pair Int Bool))))
   (models2
      ((q Form) (x (list (list (pair Int Bool)))))
      (list (list (pair Int Bool))))
   (models
      ((x (list (list (pair Int Bool)))) (q Form)
       (y (list (list (pair Int Bool)))))
      (list (list (pair Int Bool)))))
  ((match x
     (case (& p q) (models2 q (models3 p y)))
     (case (Not z)
       (match z
         (case (& r q2) (++ (models3 (Not r) y) (models3 (& r (Not q2)) y)))
         (case (Not p2) (models3 p2 y))
         (case (Var x2)
           (ite
             (not (or2 (models4 x2 y)))
             (cons (cons (pair2 x2 false) (models5 x2 y))
               (as nil (list (list (pair Int Bool)))))
             (as nil (list (list (pair Int Bool))))))))
     (case (Var x3)
       (ite
         (not (or2 (models6 x3 y)))
         (cons (cons (pair2 x3 true) (models7 x3 y))
           (as nil (list (list (pair Int Bool)))))
         (as nil (list (list (pair Int Bool)))))))
   (match x
     (case nil (as nil (list (list (pair Int Bool)))))
     (case (cons y z) (models z q (models3 q y))))
   (match y
     (case nil (models2 q x))
     (case (cons z x2) (cons z (models x q x2))))))
(assert-not
  (forall ((p Form))
    (formula p (models3 p (as nil (list (pair Int Bool)))))))
(check-sat)
