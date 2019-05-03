; Propositional solver
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Form
  ((|:&:| (|proj1-:&:| Form) (|proj2-:&:| Form))
   (Not (proj1-Not Form)) (Var (proj1-Var Int))))
(define-fun-rec
  or2
  ((x (list Bool))) Bool
  (match x
    ((nil false)
     ((cons y xs) (or y (or2 xs))))))
(define-fun-rec
  models7
  ((x Int) (y (list (pair Int Bool)))) (list (pair Int Bool))
  (match y
    ((nil (_ nil (pair Int Bool)))
     ((cons z xs)
      (ite
        (distinct x (match z (((pair2 x2 y2) x2)))) (cons z (models7 x xs))
        (models7 x xs))))))
(define-fun-rec
  models6
  ((x Int) (y (list (pair Int Bool)))) (list Bool)
  (match y
    ((nil (_ nil Bool))
     ((cons z x2)
      (match z
        (((pair2 y2 x3)
          (ite x3 (models6 x x2) (cons (= x y2) (models6 x x2))))))))))
(define-fun-rec
  models5
  ((x Int) (y (list (pair Int Bool)))) (list (pair Int Bool))
  (match y
    ((nil (_ nil (pair Int Bool)))
     ((cons z xs)
      (ite
        (distinct x (match z (((pair2 x2 y2) x2)))) (cons z (models5 x xs))
        (models5 x xs))))))
(define-fun-rec
  models4
  ((x Int) (y (list (pair Int Bool)))) (list Bool)
  (match y
    ((nil (_ nil Bool))
     ((cons z x2)
      (match z
        (((pair2 y2 x3)
          (ite x3 (cons (= x y2) (models4 x x2)) (models4 x x2)))))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
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
     (((|:&:| p q) (models2 q (models3 p y)))
      ((Not z)
       (match z
         (((|:&:| r q2)
           (++ (models3 (Not r) y) (models3 (|:&:| r (Not q2)) y)))
          ((Not p2) (models3 p2 y))
          ((Var x2)
           (ite
             (not (or2 (models4 x2 y)))
             (cons (cons (pair2 x2 false) (models5 x2 y))
               (_ nil (list (pair Int Bool))))
             (_ nil (list (pair Int Bool))))))))
      ((Var x3)
       (ite
         (not (or2 (models6 x3 y)))
         (cons (cons (pair2 x3 true) (models7 x3 y))
           (_ nil (list (pair Int Bool))))
         (_ nil (list (pair Int Bool)))))))
   (match x
     ((nil (_ nil (list (pair Int Bool))))
      ((cons y z) (models z q (models3 q y)))))
   (match y
     ((nil (models2 q x))
      ((cons z x2) (cons z (models x q x2)))))))
(define-fun
  valid
  ((x Form)) Bool
  (match (models3 (Not x) (_ nil (pair Int Bool)))
    ((nil true)
     ((cons y z) false))))
(prove (forall ((p Form)) (= (valid (|:&:| p p)) (valid p))))
