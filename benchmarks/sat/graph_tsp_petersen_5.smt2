(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(define-fun-rec
  petersen3
    ((x Nat) (y (list Nat))) (list (Pair Nat Nat))
    (match y
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons z x2) (cons (Pair2 z (plus x z)) (petersen3 x x2)))))
(define-fun-rec
  petersen2
    ((x Nat) (y (list (Pair Nat Nat)))) (list (list (Pair Nat Nat)))
    (match y
      (case nil (as nil (list (list (Pair Nat Nat)))))
      (case (cons z x2)
        (match z
          (case (Pair2 u v)
            (cons
              (cons z
                (cons (Pair2 (plus x u) (plus x v))
                  (as nil (list (Pair Nat Nat)))))
              (petersen2 x x2)))))))
(define-fun-rec
  petersen
    ((x (list Nat))) (list (Pair Nat Nat))
    (match x
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons y z) (cons (Pair2 y (S y)) (petersen z)))))
(define-fun-rec
  or2
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
(define-fun-rec
  max2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (S (max2 z x2)))))))
(define-fun-rec
  maximum
    ((x Nat) (y (list (Pair Nat Nat)))) Nat
    (match y
      (case nil x)
      (case (cons z yzs)
        (match z
          (case (Pair2 y2 z2) (maximum (max2 x (max2 y2 z2)) yzs))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  (par (t)
    (last
       ((x t) (y (list t))) t
       (match y
         (case nil x)
         (case (cons z ys) (last z ys))))))
(define-fun-rec
  ge
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z true)
      (case (S z)
        (match x
          (case Z false)
          (case (S x2) (ge x2 z))))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun-rec
  path2
    ((x Nat) (y Nat) (z (list (Pair Nat Nat)))) (list Bool)
    (match z
      (case nil (as nil (list Bool)))
      (case (cons x2 x3)
        (match x2
          (case (Pair2 u v)
            (cons
              (or (and (equal u x) (equal v y)) (and (equal u y) (equal v x)))
              (path2 x y x3)))))))
(define-fun-rec
  path
    ((x (list Nat)) (y (list (Pair Nat Nat)))) Bool
    (match x
      (case nil true)
      (case (cons z x2)
        (match x2
          (case nil true)
          (case (cons y2 xs) (and (or2 (path2 z y2 y)) (path x2 y)))))))
(define-fun-rec
  enumFromTo
    ((x Nat) (y Nat)) (list Nat)
    (ite (ge x y) (as nil (list Nat)) (cons x (enumFromTo (S x) y))))
(define-fun-rec
  elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (equal x z) (elem x ys)))))
(define-fun-rec
  unique
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (not (elem y xs)) (unique xs)))))
(define-fun
  tour
    ((x (list Nat)) (y (list (Pair Nat Nat)))) Bool
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
              (case (Pair2 u v)
                (and (equal x3 (last x3 x4))
                  (and (path x y)
                    (and (unique x4)
                      (equal (length x) (S (S (maximum (max2 u v) vs))))))))))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a)
    (concat2
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons xs xss) (append xs (concat2 xss)))))))
(assert-not
  (forall ((q (list Nat)))
    (not
      (tour q
        (let ((pn (S (S (S (S Z))))))
          (append
            (concat2
              (petersen2 (S pn)
                (cons (Pair2 pn Z) (petersen (enumFromTo Z pn)))))
            (petersen3 (S pn) (enumFromTo Z (S pn)))))))))
(check-sat)
