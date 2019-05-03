(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  primEnumFromTo
  ((x Int) (y Int)) (list Int)
  (ite (> x y) (_ nil Int) (cons x (primEnumFromTo (+ 1 x) y))))
(define-fun-rec
  path
  ((x Int) (y Int) (z (list (pair Int Int)))) (list Bool)
  (match z
    ((nil (_ nil Bool))
     ((cons x2 x3)
      (match x2
        (((pair2 u v)
          (cons (or (and (= u x) (= v y)) (and (= u y) (= v x)))
            (path x y x3)))))))))
(define-fun-rec
  or2
  ((x (list Bool))) Bool
  (match x
    ((nil false)
     ((cons y xs) (or y (or2 xs))))))
(define-fun-rec
  path2
  ((x (list Int)) (y (list (pair Int Int)))) Bool
  (match x
    ((nil true)
     ((cons z x2)
      (match x2
        ((nil true)
         ((cons y2 xs) (and (or2 (path z y2 y)) (path2 x2 y)))))))))
(define-fun-rec
  maximum-maximum1
  (par (t) (((x t) (y (list (pair t t)))) t))
  (match y
    ((nil x)
     ((cons z yzs)
      (match z
        (((pair2 y2 z2)
          (let ((y3 (ite (<= y2 z2) z2 y2)))
            (ite
              (<= x y3) (maximum-maximum1 y3 yzs)
              (maximum-maximum1 x yzs))))))))))
(define-fun-rec
  length
  (par (a) (((x (list a))) Int))
  (match x
    ((nil 0)
     ((cons y l) (+ 1 (length l))))))
(define-fun-rec
  last
  (par (t) (((x t) (y (list t))) t))
  (match y
    ((nil x)
     ((cons z ys) (last z ys)))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  unique
  (par (a) (((x (list a))) Bool))
  (match x
    ((nil true)
     ((cons y xs) (ite (elem y xs) false (unique xs))))))
(define-fun
  tour
  ((x (list Int)) (y (list (pair Int Int)))) Bool
  (match x
    ((nil
      (match y
        ((nil true)
         ((cons z x2) false))))
     ((cons x3 x4)
      (match y
        ((nil false)
         ((cons x5 vs)
          (match x5
            (((pair2 u v)
              (and (= x3 (last x3 x4))
                (and (path2 x y)
                  (and (unique x4)
                    (= (length x)
                      (ite
                        (<= u v) (+ 2 (maximum-maximum1 v vs))
                        (+ 2 (maximum-maximum1 u vs)))))))))))))))))
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
  (forall ((p (list Int)))
    (not
      (tour p
        (++ (cons (pair2 (- 5 1) 0) (dodeca (primEnumFromTo 0 (- 5 1))))
          (++ (dodeca2 5 (primEnumFromTo 0 5))
            (++ (dodeca3 5 (primEnumFromTo 0 5))
              (++
                (cons (pair2 5 (+ (+ 5 5) (- 5 1)))
                  (dodeca4 5 (primEnumFromTo 0 (- 5 1))))
                (++ (dodeca5 5 (primEnumFromTo 0 5))
                  (cons (pair2 (+ (+ (+ 5 5) 5) (- 5 1)) (+ (+ 5 5) 5))
                    (dodeca6 5 (primEnumFromTo 0 (- 5 1)))))))))))))
