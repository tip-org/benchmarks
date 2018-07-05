(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((B (I) (O))))
(define-fun-rec
  primEnumFromTo
    ((x Int) (y Int)) (list Int)
    (ite (> x y) (_ nil Int) (cons x (primEnumFromTo (+ 1 x) y))))
(define-fun-rec
  petersen3
    ((x Int) (y (list Int))) (list (pair Int Int))
    (match y
      (case nil (_ nil (pair Int Int)))
      (case (cons z x2) (cons (pair2 z (+ x z)) (petersen3 x x2)))))
(define-fun-rec
  petersen2
    ((x (list Int))) (list (pair Int Int))
    (match x
      (case nil (_ nil (pair Int Int)))
      (case (cons y z) (cons (pair2 y (+ 1 y)) (petersen2 z)))))
(define-fun-rec
  petersen
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
  or2
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
(define-fun-rec
  (par (t)
    (maximum-maximum1
       ((x t) (y (list (pair t t)))) t
       (match y
         (case nil x)
         (case (cons z yzs)
           (match z
             (case (pair2 y2 z2)
               (let ((y3 (ite (<= y2 z2) z2 y2)))
                 (ite
                   (<= x y3) (maximum-maximum1 y3 yzs)
                   (maximum-maximum1 x yzs))))))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y l) (+ 1 (length l)))))))
(define-fun-rec
  (par (t)
    (last
       ((x t) (y (list t))) t
       (match y
         (case nil x)
         (case (cons z ys) (last z ys))))))
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
      (case nil (_ nil (pair (list B) (list B))))
      (case (cons y z)
        (match y
          (case (pair2 u v) (cons (pair2 (bin u) (bin v)) (bgraph z)))))))
(define-fun-rec
  beq
    ((x (list B)) (y (list B))) Bool
    (match x
      (case nil
        (match y
          (case nil true)
          (case (cons z x2) false)))
      (case (cons x3 xs)
        (match x3
          (case I
            (match y
              (case nil false)
              (case (cons x4 ys)
                (match x4
                  (case I (beq xs ys))
                  (case O false)))))
          (case O
            (match y
              (case nil false)
              (case (cons x5 zs)
                (match x5
                  (case I false)
                  (case O (beq xs zs))))))))))
(define-fun-rec
  bpath
    ((x (list B)) (y (list B)) (z (list (pair (list B) (list B)))))
    (list Bool)
    (match z
      (case nil (_ nil Bool))
      (case (cons x2 x3)
        (match x2
          (case (pair2 u v)
            (cons (or (and (beq u x) (beq v y)) (and (beq u y) (beq v x)))
              (bpath x y x3)))))))
(define-fun-rec
  bpath2
    ((x (list (list B))) (y (list (pair (list B) (list B))))) Bool
    (match x
      (case nil true)
      (case (cons z x2)
        (match x2
          (case nil true)
          (case (cons y2 xs) (and (or2 (bpath z y2 y)) (bpath2 x2 y)))))))
(define-fun-rec
  belem
    ((x (list B)) (y (list (list B)))) (list Bool)
    (match y
      (case nil (_ nil Bool))
      (case (cons z x2) (cons (beq x z) (belem x x2)))))
(define-fun
  belem2 ((x (list B)) (y (list (list B)))) Bool (or2 (belem x y)))
(define-fun-rec
  bunique
    ((x (list (list B)))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (not (belem2 y xs)) (bunique xs)))))
(define-fun
  btour
    ((x (list (list B))) (y (list (pair Int Int)))) Bool
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
                (and (beq x3 (last x3 x4))
                  (and (bpath2 x (bgraph y))
                    (and (bunique x4)
                      (= (length x)
                        (ite
                          (<= u v) (+ 1 (+ 1 (maximum-maximum1 v vs)))
                          (+ 1 (+ 1 (maximum-maximum1 u vs)))))))))))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (concat
       ((x (list (list a)))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ y (concat xs)))))))
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
