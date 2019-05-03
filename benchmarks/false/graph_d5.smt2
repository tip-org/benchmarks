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
  dodeca6
  ((x Int) (y (list Int))) (list (pair Int Int))
  (match y
    ((nil (_ nil (pair Int Int)))
     ((cons z x2)
      (cons (pair2 (+ (+ (+ x x) x) z) (+ (+ (+ x x) x) (+ 1 z)))
        (dodeca6 x x2))))))
(define-fun-rec
  dodeca5
  ((x Int) (y (list Int))) (list (pair Int Int))
  (match y
    ((nil (_ nil (pair Int Int)))
     ((cons z x2)
      (cons (pair2 (+ (+ x x) z) (+ (+ (+ x x) x) z)) (dodeca5 x x2))))))
(define-fun-rec
  dodeca4
  ((x Int) (y (list Int))) (list (pair Int Int))
  (match y
    ((nil (_ nil (pair Int Int)))
     ((cons z x2)
      (cons (pair2 (+ x (+ 1 z)) (+ (+ x x) z)) (dodeca4 x x2))))))
(define-fun-rec
  dodeca3
  ((x Int) (y (list Int))) (list (pair Int Int))
  (match y
    ((nil (_ nil (pair Int Int)))
     ((cons z x2)
      (cons (pair2 (+ x z) (+ (+ x x) z)) (dodeca3 x x2))))))
(define-fun-rec
  dodeca2
  ((x Int) (y (list Int))) (list (pair Int Int))
  (match y
    ((nil (_ nil (pair Int Int)))
     ((cons z x2) (cons (pair2 z (+ x z)) (dodeca2 x x2))))))
(define-fun-rec
  dodeca
  ((x (list Int))) (list (pair Int Int))
  (match x
    ((nil (_ nil (pair Int Int)))
     ((cons y z) (cons (pair2 y (+ 1 y)) (dodeca z))))))
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
(define-fun
  dodeca7
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
  (forall ((a (list Int)))
    (or
      (not
        (colouring2
          (++ (cons (pair2 (- 5 1) 0) (dodeca (primEnumFromTo 0 (- 5 1))))
            (++ (dodeca2 5 (primEnumFromTo 0 5))
              (++ (dodeca3 5 (primEnumFromTo 0 5))
                (++
                  (cons (pair2 5 (+ (+ 5 5) (- 5 1)))
                    (dodeca4 5 (primEnumFromTo 0 (- 5 1))))
                  (++ (dodeca5 5 (primEnumFromTo 0 5))
                    (cons (pair2 (+ (+ (+ 5 5) 5) (- 5 1)) (+ (+ 5 5) 5))
                      (dodeca6 5 (primEnumFromTo 0 (- 5 1)))))))))
          a))
      (not (and2 (formula a))))))
