(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Maybe (par (a) ((Nothing) (Just (proj1-Just a)))))
(define-fun-rec
  primEnumFromTo
  ((x Int) (y Int)) (list Int)
  (ite (> x y) (_ nil Int) (cons x (primEnumFromTo (+ 1 x) y))))
(define-fun-rec
  petersen3
  ((x Int) (y (list Int))) (list (pair Int Int))
  (match y
    ((nil (_ nil (pair Int Int)))
     ((cons z x2) (cons (pair2 z (+ x z)) (petersen3 x x2))))))
(define-fun-rec
  petersen2
  ((x (list Int))) (list (pair Int Int))
  (match x
    ((nil (_ nil (pair Int Int)))
     ((cons y z) (cons (pair2 y (+ 1 y)) (petersen2 z))))))
(define-fun-rec
  petersen
  ((x Int) (y (list (pair Int Int)))) (list (list (pair Int Int)))
  (match y
    ((nil (_ nil (list (pair Int Int))))
     ((cons z x2)
      (match z
        (((pair2 u v)
          (cons
            (cons z (cons (pair2 (+ x u) (+ x v)) (_ nil (pair Int Int))))
            (petersen x x2)))))))))
(define-fun-rec
  index
  (par (a) (((x (list a)) (y Int)) (Maybe a)))
  (match x
    ((nil (_ Nothing a))
     ((cons z xs) (ite (= y 0) (Just z) (index xs (- y 1)))))))
(define-fun-rec
  formula
  ((x (list Int))) (list Bool)
  (match x
    ((nil (_ nil Bool))
     ((cons y z) (cons (< y 3) (formula z))))))
(define-fun-rec
  colouring
  ((a (list Int)) (x (list (pair Int Int)))) (list Bool)
  (match x
    ((nil (_ nil Bool))
     ((cons y z)
      (match y
        (((pair2 u v)
          (match (index a u)
            ((Nothing (cons false (colouring a z)))
             ((Just c1)
              (match (index a v)
                ((Nothing (cons false (colouring a z)))
                 ((Just c2) (cons (distinct c1 c2) (colouring a z)))))))))))))))
(define-fun-rec
  and2
  ((x (list Bool))) Bool
  (match x
    ((nil true)
     ((cons y xs) (and y (and2 xs))))))
(define-fun
  colouring2
  ((x (list (pair Int Int))) (y (list Int))) Bool
  (and2 (colouring y x)))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  concat
  (par (a) (((x (list (list a)))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (++ y (concat xs))))))
(define-fun
  petersen4
  ((x Int)) (list (pair Int Int))
  (ite
    (= x 0) (_ nil (pair Int Int))
    (++
      (concat
        (petersen x
          (cons (pair2 (- x 1) 0) (petersen2 (primEnumFromTo 0 (- x 1))))))
      (petersen3 x (primEnumFromTo 0 x)))))
(prove
  (forall ((a (list Int)))
    (or
      (not
        (colouring2
          (++
            (concat
              (petersen 7
                (cons (pair2 (- 7 1) 0) (petersen2 (primEnumFromTo 0 (- 7 1))))))
            (petersen3 7 (primEnumFromTo 0 7)))
          a))
      (not (and2 (formula a))))))
