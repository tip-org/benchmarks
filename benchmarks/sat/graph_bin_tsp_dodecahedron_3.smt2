(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes () ((B (I) (O))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
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
  half
    ((x Nat)) Nat
    (match x
      (case Z Z)
      (case (S y)
        (match y
          (case Z Z)
          (case (S n) (S (half n)))))))
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
  even
    ((x Nat)) Bool
    (match x
      (case Z true)
      (case (S y)
        (match y
          (case Z false)
          (case (S z) (even z))))))
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
  enumFromTo
    ((x Nat) (y Nat)) (list Nat)
    (ite (ge x y) (as nil (list Nat)) (cons x (enumFromTo (S x) y))))
(define-fun-rec
  dodeca6
    ((x Nat) (y (list Nat))) (list (Pair Nat Nat))
    (match y
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons z x2)
        (cons
          (Pair2 (plus (plus (plus x x) x) z)
            (plus (plus (plus x x) x) (S z)))
          (dodeca6 x x2)))))
(define-fun-rec
  dodeca5
    ((x Nat) (y (list Nat))) (list (Pair Nat Nat))
    (match y
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons z x2)
        (cons (Pair2 (plus (plus x x) z) (plus (plus (plus x x) x) z))
          (dodeca5 x x2)))))
(define-fun-rec
  dodeca4
    ((x Nat) (y (list Nat))) (list (Pair Nat Nat))
    (match y
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons z x2)
        (cons (Pair2 (plus x (S z)) (plus (plus x x) z)) (dodeca4 x x2)))))
(define-fun-rec
  dodeca3
    ((x Nat) (y (list Nat))) (list (Pair Nat Nat))
    (match y
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons z x2)
        (cons (Pair2 (plus x z) (plus (plus x x) z)) (dodeca3 x x2)))))
(define-fun-rec
  dodeca2
    ((x Nat) (y (list Nat))) (list (Pair Nat Nat))
    (match y
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons z x2) (cons (Pair2 z (plus x z)) (dodeca2 x x2)))))
(define-fun-rec
  dodeca
    ((x (list Nat))) (list (Pair Nat Nat))
    (match x
      (case nil (as nil (list (Pair Nat Nat))))
      (case (cons y z) (cons (Pair2 y (S y)) (dodeca z)))))
(define-fun-rec
  bin
    ((x Nat)) (list B)
    (match x
      (case Z (as nil (list B)))
      (case (S y)
        (ite (even x) (cons O (bin (half x))) (cons I (bin (half x)))))))
(define-fun-rec
  bgraph
    ((x (list (Pair Nat Nat)))) (list (Pair (list B) (list B)))
    (match x
      (case nil (as nil (list (Pair (list B) (list B)))))
      (case (cons y z)
        (match y
          (case (Pair2 u v) (cons (Pair2 (bin u) (bin v)) (bgraph z)))))))
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
  bpath2
    ((x (list B)) (y (list B)) (z (list (Pair (list B) (list B)))))
    (list Bool)
    (match z
      (case nil (as nil (list Bool)))
      (case (cons x2 x3)
        (match x2
          (case (Pair2 u v)
            (cons (or (and (beq u x) (beq v y)) (and (beq u y) (beq v x)))
              (bpath2 x y x3)))))))
(define-fun-rec
  bpath
    ((x (list (list B))) (y (list (Pair (list B) (list B))))) Bool
    (match x
      (case nil true)
      (case (cons z x2)
        (match x2
          (case nil true)
          (case (cons y2 xs) (and (or2 (bpath2 z y2 y)) (bpath x2 y)))))))
(define-fun-rec
  belem2
    ((x (list B)) (y (list (list B)))) (list Bool)
    (match y
      (case nil (as nil (list Bool)))
      (case (cons z x2) (cons (beq x z) (belem2 x x2)))))
(define-fun
  belem ((x (list B)) (y (list (list B)))) Bool (or2 (belem2 x y)))
(define-fun-rec
  bunique
    ((x (list (list B)))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (not (belem y xs)) (bunique xs)))))
(define-fun
  btour
    ((x (list (list B))) (y (list (Pair Nat Nat)))) Bool
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
                (and (beq x3 (last x3 x4))
                  (and (bpath x (bgraph y))
                    (and (bunique x4)
                      (equal (length x) (S (S (maximum (max2 u v) vs))))))))))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(assert-not
  (forall ((q (list (list B))))
    (not
      (btour q
        (let ((pn (S (S Z))))
          (append
            (append
              (append
                (append
                  (append (cons (Pair2 pn Z) (dodeca (enumFromTo Z pn)))
                    (dodeca2 (S pn) (enumFromTo Z (S pn))))
                  (dodeca3 (S pn) (enumFromTo Z (S pn))))
                (cons (Pair2 (S pn) (plus (plus (S pn) (S pn)) pn))
                  (dodeca4 (S pn) (enumFromTo Z pn))))
              (dodeca5 (S pn) (enumFromTo Z (S pn))))
            (cons
              (Pair2 (plus (plus (plus (S pn) (S pn)) (S pn)) pn)
                (plus (plus (S pn) (S pn)) (S pn)))
              (dodeca6 (S pn) (enumFromTo Z pn)))))))))
(check-sat)
