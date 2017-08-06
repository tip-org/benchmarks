; Propositional solver
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Form :source Propositional.Form
     (|:&:| :source |Propositional.:&:| (|proj1-:&:| Form)
       (|proj2-:&:| Form))
     (Not :source Propositional.Not (proj1-Not Form))
     (Var :source Propositional.Var (proj1-Var Int)))))
(define-fun-rec
  or2 :let :source Prelude.or
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
(define-fun-rec
  models7 :let
    ((x Int) (y (list (pair Int Bool)))) (list (pair Int Bool))
    (match y
      (case nil (_ nil (pair Int Bool)))
      (case (cons z xs)
        (ite
          (distinct x (match z (case (pair2 x2 y2) x2)))
          (cons z (models7 x xs)) (models7 x xs)))))
(define-fun-rec
  models6 :let
    ((x Int) (y (list (pair Int Bool)))) (list Bool)
    (match y
      (case nil (_ nil Bool))
      (case (cons z x2)
        (match z
          (case (pair2 y2 x3)
            (ite x3 (models6 x x2) (cons (= x y2) (models6 x x2))))))))
(define-fun-rec
  models5 :let
    ((x Int) (y (list (pair Int Bool)))) (list (pair Int Bool))
    (match y
      (case nil (_ nil (pair Int Bool)))
      (case (cons z xs)
        (ite
          (distinct x (match z (case (pair2 x2 y2) x2)))
          (cons z (models5 x xs)) (models5 x xs)))))
(define-fun-rec
  models4 :let
    ((x Int) (y (list (pair Int Bool)))) (list Bool)
    (match y
      (case nil (_ nil Bool))
      (case (cons z x2)
        (match z
          (case (pair2 y2 x3)
            (ite x3 (cons (= x y2) (models4 x x2)) (models4 x x2)))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((models3 :source Propositional.models
      ((x Form) (y (list (pair Int Bool))))
      (list (list (pair Int Bool))))
   (models2 :let
      ((q Form) (x (list (list (pair Int Bool)))))
      (list (list (pair Int Bool))))
   (models :let
      ((x (list (list (pair Int Bool)))) (q Form)
       (y (list (list (pair Int Bool)))))
      (list (list (pair Int Bool)))))
  ((match x
     (case (|:&:| p q) (models2 q (models3 p y)))
     (case (Not z)
       (match z
         (case (|:&:| r q2)
           (++ (models3 (Not r) y) (models3 (|:&:| r (Not q2)) y)))
         (case (Not p2) (models3 p2 y))
         (case (Var x2)
           (ite
             (not (or2 (models4 x2 y)))
             (cons (cons (pair2 x2 false) (models5 x2 y))
               (_ nil (list (pair Int Bool))))
             (_ nil (list (pair Int Bool)))))))
     (case (Var x3)
       (ite
         (not (or2 (models6 x3 y)))
         (cons (cons (pair2 x3 true) (models7 x3 y))
           (_ nil (list (pair Int Bool))))
         (_ nil (list (pair Int Bool))))))
   (match x
     (case nil (_ nil (list (pair Int Bool))))
     (case (cons y z) (models z q (models3 q y))))
   (match y
     (case nil (models2 q x))
     (case (cons z x2) (cons z (models x q x2))))))
(define-fun
  valid :source Propositional.valid
    ((x Form)) Bool
    (match (models3 (Not x) (_ nil (pair Int Bool)))
      (case nil true)
      (case (cons y z) false)))
(prove
  :source Propositional.prop_AndCommutative
  (forall ((p Form) (q Form))
    (= (valid (|:&:| p q)) (valid (|:&:| q p)))))
