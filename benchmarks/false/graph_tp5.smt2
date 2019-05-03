(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
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
  (forall ((p (list Int)))
    (not
      (tour p
        (++
          (concat
            (petersen 5
              (cons (pair2 (- 5 1) 0) (petersen2 (primEnumFromTo 0 (- 5 1))))))
          (petersen3 5 (primEnumFromTo 0 5)))))))
