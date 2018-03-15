(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  primEnumFromTo :source Prelude.primEnumFromTo
    ((x Int) (y Int)) (list Int)
    (ite (> x y) (_ nil Int) (cons x (primEnumFromTo (+ 1 x) y))))
(define-fun-rec
  path :let
    ((x Int) (y Int) (z (list (pair Int Int)))) (list Bool)
    (match z
      (case nil (_ nil Bool))
      (case (cons x2 x3)
        (match x2
          (case (pair2 u v)
            (cons (or (and (= u x) (= v y)) (and (= u y) (= v x)))
              (path x y x3)))))))
(define-fun-rec
  or2 :let :source Prelude.or
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
(define-fun-rec
  path2 :source Graph.path
    ((x (list Int)) (y (list (pair Int Int)))) Bool
    (match x
      (case nil true)
      (case (cons z x2)
        (match x2
          (case nil true)
          (case (cons y2 xs) (and (or2 (path z y2 y)) (path2 x2 y)))))))
(define-fun-rec
  (par (t)
    (maximum-maximum1 :let :source Graph.maximum
       ((x t) (y (list (pair t t)))) t
       (match y
         (case nil x)
         (case (cons z yzs)
           (match z
             (case (pair2 y2 z2)
               (maximum-maximum1
                 (let ((y3 (ite (<= y2 z2) z2 y2))) (ite (<= x y3) y3 x))
                 yzs))))))))
(define-fun-rec
  (par (a)
    (length :source Prelude.length
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y l) (+ 1 (length l)))))))
(define-fun-rec
  (par (t)
    (last :source Graph.last
       ((x t) (y (list t))) t
       (match y
         (case nil x)
         (case (cons z ys) (last z ys))))))
(define-fun-rec
  (par (a)
    (elem :let :source Prelude.elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (unique :source Graph.unique
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y xs) (ite (elem y xs) false (unique xs)))))))
(define-fun
  tour :source Graph.tour
    ((x (list Int)) (y (list (pair Int Int)))) Bool
    (match x
      (case nil
        (match y
          (case nil true)
          (case (cons z x2) false)))
      (case (cons x3 x4)
        (match y
          (case nil false)
          (case (cons x5 vs)
            (match x5
              (case (pair2 u v)
                (and (= x3 (last x3 x4))
                  (and (path2 x y)
                    (and (unique x4)
                      (= (length x)
                        (ite
                          (<= u v) (+ 2 (maximum-maximum1 v vs))
                          (+ 2 (maximum-maximum1 u vs))))))))))))))
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
  :source Graph.prop_t5
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
