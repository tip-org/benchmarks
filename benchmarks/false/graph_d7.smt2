(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Maybe :source Prelude.Maybe (Nothing :source Prelude.Nothing)
     (Just :source Prelude.Just (proj1-Just a)))))
(define-fun-rec
  primEnumFromTo :source Prelude.primEnumFromTo
    ((x Int) (y Int)) (list Int)
    (ite (> x y) (_ nil Int) (cons x (primEnumFromTo (+ 1 x) y))))
(define-fun-rec
  (par (a)
    (index :source Graph.index
       ((x (list a)) (y Int)) (Maybe a)
       (match x
         (case nil (_ Nothing a))
         (case (cons z xs) (ite (= y 0) (Just z) (index xs (- y 1))))))))
(define-fun-rec
  formula :let
    ((x (list Int))) (list Bool)
    (match x
      (case nil (_ nil Bool))
      (case (cons y z) (cons (< y 3) (formula z)))))
(define-fun-rec
  dodeca6 :let
    ((x Int) (y (list Int))) (list (pair Int Int))
    (match y
      (case nil (_ nil (pair Int Int)))
      (case (cons z x2)
        (cons (pair2 (+ (+ (+ x x) x) z) (+ (+ (+ x x) x) (+ 1 z)))
          (dodeca6 x x2)))))
(define-fun-rec
  dodeca5 :let
    ((x Int) (y (list Int))) (list (pair Int Int))
    (match y
      (case nil (_ nil (pair Int Int)))
      (case (cons z x2)
        (cons (pair2 (+ (+ x x) z) (+ (+ (+ x x) x) z)) (dodeca5 x x2)))))
(define-fun-rec
  dodeca4 :let
    ((x Int) (y (list Int))) (list (pair Int Int))
    (match y
      (case nil (_ nil (pair Int Int)))
      (case (cons z x2)
        (cons (pair2 (+ x (+ 1 z)) (+ (+ x x) z)) (dodeca4 x x2)))))
(define-fun-rec
  dodeca3 :let
    ((x Int) (y (list Int))) (list (pair Int Int))
    (match y
      (case nil (_ nil (pair Int Int)))
      (case (cons z x2)
        (cons (pair2 (+ x z) (+ (+ x x) z)) (dodeca3 x x2)))))
(define-fun-rec
  dodeca2 :let
    ((x Int) (y (list Int))) (list (pair Int Int))
    (match y
      (case nil (_ nil (pair Int Int)))
      (case (cons z x2) (cons (pair2 z (+ x z)) (dodeca2 x x2)))))
(define-fun-rec
  dodeca :let
    ((x (list Int))) (list (pair Int Int))
    (match x
      (case nil (_ nil (pair Int Int)))
      (case (cons y z) (cons (pair2 y (+ 1 y)) (dodeca z)))))
(define-fun-rec
  colouring :let
    ((a (list Int)) (x (list (pair Int Int)))) (list Bool)
    (match x
      (case nil (_ nil Bool))
      (case (cons y z)
        (match y
          (case (pair2 u v)
            (match (index a u)
              (case Nothing (cons false (colouring a z)))
              (case (Just c1)
                (match (index a v)
                  (case Nothing (cons false (colouring a z)))
                  (case (Just c2) (cons (distinct c1 c2) (colouring a z)))))))))))
(define-fun-rec
  and2 :let :source Prelude.and
    ((x (list Bool))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and y (and2 xs)))))
(define-fun
  colouring2 :source Graph.colouring
    ((x (list (pair Int Int))) (y (list Int))) Bool
    (and2 (colouring y x)))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun
  dodeca7 :source Graph.dodeca
    ((x Int)) (list (pair Int Int))
    (ite
      (= x 0) (_ nil (pair Int Int))
      (++ (cons (pair2 (- x 1) 0) (dodeca (primEnumFromTo 0 (- x 1))))
        (++ (dodeca2 x (primEnumFromTo 0 x))
          (++ (dodeca3 x (primEnumFromTo 0 x))
            (++
              (cons (pair2 x (+ (+ x x) (- x 1)))
                (dodeca4 x (primEnumFromTo 0 (- x 1))))
              (++ (dodeca5 x (primEnumFromTo 0 x))
                (cons (pair2 (+ (+ (+ x x) x) (- x 1)) (+ (+ x x) x))
                  (dodeca6 x (primEnumFromTo 0 (- x 1)))))))))))
(prove
  :source Graph.prop_d7
  (forall ((a (list Int)))
    (or
      (not
        (colouring2
          (++ (cons (pair2 (- 7 1) 0) (dodeca (primEnumFromTo 0 (- 7 1))))
            (++ (dodeca2 7 (primEnumFromTo 0 7))
              (++ (dodeca3 7 (primEnumFromTo 0 7))
                (++
                  (cons (pair2 7 (+ (+ 7 7) (- 7 1)))
                    (dodeca4 7 (primEnumFromTo 0 (- 7 1))))
                  (++ (dodeca5 7 (primEnumFromTo 0 7))
                    (cons (pair2 (+ (+ (+ 7 7) 7) (- 7 1)) (+ (+ 7 7) 7))
                      (dodeca6 7 (primEnumFromTo 0 (- 7 1)))))))))
          a))
      (not (and2 (formula a))))))
