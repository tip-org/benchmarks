(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype B ((I) (O)))
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
  or2
  ((x (list Bool))) Bool
  (match x
    ((nil false)
     ((cons y xs) (or y (or2 xs))))))
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
  bin
  ((x Int)) (list B)
  (ite
    (= x 0) (_ nil B)
    (let ((md (mod x 2)))
      (ite
        (and
          (= (ite (= x 0) 0 (ite (<= x 0) (- 0 1) 1))
            (ite (<= 2 0) (- 0 (- 0 1)) (- 0 1)))
          (distinct md 0))
        (ite
          (= (- md 2) 0) (cons O (bin (div x 2))) (cons I (bin (div x 2))))
        (ite
          (= md 0) (cons O (bin (div x 2))) (cons I (bin (div x 2))))))))
(define-fun-rec
  bgraph
  ((x (list (pair Int Int)))) (list (pair (list B) (list B)))
  (match x
    ((nil (_ nil (pair (list B) (list B))))
     ((cons y z)
      (match y
        (((pair2 u v) (cons (pair2 (bin u) (bin v)) (bgraph z)))))))))
(define-fun-rec
  beq
  ((x (list B)) (y (list B))) Bool
  (match x
    ((nil
      (match y
        ((nil true)
         ((cons z x2) false))))
     ((cons x3 xs)
      (match x3
        ((I
          (match y
            ((nil false)
             ((cons x4 ys)
              (match x4
                ((I (beq xs ys))
                 (O false)))))))
         (O
          (match y
            ((nil false)
             ((cons x5 zs)
              (match x5
                ((I false)
                 (O (beq xs zs))))))))))))))
(define-fun-rec
  bpath
  ((x (list B)) (y (list B)) (z (list (pair (list B) (list B)))))
  (list Bool)
  (match z
    ((nil (_ nil Bool))
     ((cons x2 x3)
      (match x2
        (((pair2 u v)
          (cons (or (and (beq u x) (beq v y)) (and (beq u y) (beq v x)))
            (bpath x y x3)))))))))
(define-fun-rec
  bpath2
  ((x (list (list B))) (y (list (pair (list B) (list B))))) Bool
  (match x
    ((nil true)
     ((cons z x2)
      (match x2
        ((nil true)
         ((cons y2 xs) (and (or2 (bpath z y2 y)) (bpath2 x2 y)))))))))
(define-fun-rec
  belem
  ((x (list B)) (y (list (list B)))) (list Bool)
  (match y
    ((nil (_ nil Bool))
     ((cons z x2) (cons (beq x z) (belem x x2))))))
(define-fun
  belem2
  ((x (list B)) (y (list (list B)))) Bool (or2 (belem x y)))
(define-fun-rec
  bunique
  ((x (list (list B)))) Bool
  (match x
    ((nil true)
     ((cons y xs) (and (not (belem2 y xs)) (bunique xs))))))
(define-fun
  btour
  ((x (list (list B))) (y (list (pair Int Int)))) Bool
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
              (and (beq x3 (last x3 x4))
                (and (bpath2 x (bgraph y))
                  (and (bunique x4)
                    (= (length x)
                      (ite
                        (<= u v) (+ 1 (+ 1 (maximum-maximum1 v vs)))
                        (+ 1 (+ 1 (maximum-maximum1 u vs))))))))))))))))))
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
  (forall ((p (list (list B))))
    (not
      (btour p
        (++
          (concat
            (petersen 5
              (cons (pair2 (- 5 1) 0) (petersen2 (primEnumFromTo 0 (- 5 1))))))
          (petersen3 5 (primEnumFromTo 0 5)))))))
