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
  petersen3 :let
    ((x Int) (y (list Int))) (list (pair Int Int))
    (match y
      (case nil (_ nil (pair Int Int)))
      (case (cons z x2) (cons (pair2 z (+ x z)) (petersen3 x x2)))))
(define-fun-rec
  petersen2 :let
    ((x (list Int))) (list (pair Int Int))
    (match x
      (case nil (_ nil (pair Int Int)))
      (case (cons y z) (cons (pair2 y (+ 1 y)) (petersen2 z)))))
(define-fun-rec
  petersen :let
    ((x Int) (y (list (pair Int Int)))) (list (list (pair Int Int)))
    (match y
      (case nil (_ nil (list (pair Int Int))))
      (case (cons z x2)
        (match z
          (case (pair2 u v)
            (cons
              (cons z (cons (pair2 (+ x u) (+ x v)) (_ nil (pair Int Int))))
              (petersen x x2)))))))
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
(define-fun-rec
  (par (a)
    (concat :let :source Prelude.concat
       ((x (list (list a)))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ y (concat xs)))))))
(define-fun
  petersen4 :source Graph.petersen
    ((x Int)) (list (pair Int Int))
    (ite
      (= x 0) (_ nil (pair Int Int))
      (++
        (concat
          (petersen x
            (cons (pair2 (- x 1) 0) (petersen2 (primEnumFromTo 0 (- x 1))))))
        (petersen3 x (primEnumFromTo 0 x)))))
(prove
  :source Graph.prop_p9
  (forall ((a (list Int)))
    (or
      (not
        (colouring2
          (++
            (concat
              (petersen 9
                (cons (pair2 (- 9 1) 0) (petersen2 (primEnumFromTo 0 (- 9 1))))))
            (petersen3 9 (primEnumFromTo 0 9)))
          a))
      (not (and2 (formula a))))))
