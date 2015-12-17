(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(declare-datatypes ()
  ((Cell (C1) (C2) (C3) (C4) (C5) (C6) (C7) (C8) (C9))))
(define-fun-rec
  (par (a b)
    (zip
       ((x (list a)) (y (list b))) (list (Pair a b))
       (match x
         (case nil (as nil (list (Pair a b))))
         (case (cons z x2)
           (match y
             (case nil (as nil (list (Pair a b))))
             (case (cons x3 x4) (cons (Pair2 z x3) (zip x2 x4)))))))))
(define-fun-rec
  (par (a)
    (transpose3
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons y z)
           (match y
             (case nil (transpose3 z))
             (case (cons x2 t) (cons t (transpose3 z)))))))))
(define-fun-rec
  (par (a)
    (transpose2
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y z)
           (match y
             (case nil (transpose2 z))
             (case (cons h x2) (cons h (transpose2 z)))))))))
(define-fun-rec
  (par (a)
    (transpose
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons y xss)
           (match y
             (case nil (transpose xss))
             (case (cons z xs)
               (cons (cons z (transpose2 xss))
                 (transpose (cons xs (transpose3 xss)))))))))))
(define-fun-rec
  (par (a)
    (take
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z (as nil (list a)))
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons x2 x3) (cons x2 (take z x3)))))))))
(define-fun n9 () Nat (S (S (S (S (S (S (S (S (S Z))))))))))
(define-fun n6 () Nat (S (S (S (S (S (S Z)))))))
(define-fun n3 () Nat (S (S (S Z))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  isOkayBlock2
    ((x (list (Maybe Cell)))) (list Cell)
    (match x
      (case nil (as nil (list Cell)))
      (case (cons y z)
        (match y
          (case Nothing (isOkayBlock2 z))
          (case (Just n) (cons n (isOkayBlock2 z)))))))
(define-fun
  (par (t)
    (isJust
       ((x (Maybe t))) Bool
       (match x
         (case Nothing false)
         (case (Just y) true)))))
(define-funs-rec
  ((isSolved3
      ((x (list (list (Maybe Cell)))) (y (list (Maybe Cell))))
      (list Bool))
   (isSolved2 ((x (list (list (Maybe Cell))))) (list Bool)))
  ((match y
     (case nil (isSolved2 x))
     (case (cons z x2) (cons (isJust z) (isSolved3 x x2))))
   (match x
     (case nil (as nil (list Bool)))
     (case (cons y z) (isSolved3 z y)))))
(define-fun
  example
    () (list (list (Maybe Cell)))
    (cons
      (cons (Just C3)
        (cons (Just C6)
          (cons (as Nothing (Maybe Cell))
            (cons (as Nothing (Maybe Cell))
              (cons (Just C7)
                (cons (Just C1)
                  (cons (Just C2)
                    (cons (as Nothing (Maybe Cell))
                      (cons (as Nothing (Maybe Cell))
                        (as nil (list (Maybe Cell))))))))))))
      (cons
        (cons (as Nothing (Maybe Cell))
          (cons (Just C5)
            (cons (as Nothing (Maybe Cell))
              (cons (as Nothing (Maybe Cell))
                (cons (as Nothing (Maybe Cell))
                  (cons (as Nothing (Maybe Cell))
                    (cons (Just C1)
                      (cons (Just C8)
                        (cons (as Nothing (Maybe Cell))
                          (as nil (list (Maybe Cell))))))))))))
        (cons
          (cons (as Nothing (Maybe Cell))
            (cons (as Nothing (Maybe Cell))
              (cons (Just C9)
                (cons (Just C2)
                  (cons (as Nothing (Maybe Cell))
                    (cons (Just C4)
                      (cons (Just C7)
                        (cons (as Nothing (Maybe Cell))
                          (cons (as Nothing (Maybe Cell))
                            (as nil (list (Maybe Cell))))))))))))
          (cons
            (cons (as Nothing (Maybe Cell))
              (cons (as Nothing (Maybe Cell))
                (cons (as Nothing (Maybe Cell))
                  (cons (as Nothing (Maybe Cell))
                    (cons (Just C1)
                      (cons (Just C3)
                        (cons (as Nothing (Maybe Cell))
                          (cons (Just C2)
                            (cons (Just C8) (as nil (list (Maybe Cell))))))))))))
            (cons
              (cons (Just C4)
                (cons (as Nothing (Maybe Cell))
                  (cons (as Nothing (Maybe Cell))
                    (cons (Just C5)
                      (cons (as Nothing (Maybe Cell))
                        (cons (Just C2)
                          (cons (as Nothing (Maybe Cell))
                            (cons (as Nothing (Maybe Cell))
                              (cons (Just C9) (as nil (list (Maybe Cell))))))))))))
              (cons
                (cons (Just C2)
                  (cons (Just C7)
                    (cons (as Nothing (Maybe Cell))
                      (cons (Just C4)
                        (cons (Just C6)
                          (cons (as Nothing (Maybe Cell))
                            (cons (as Nothing (Maybe Cell))
                              (cons (as Nothing (Maybe Cell))
                                (cons (as Nothing (Maybe Cell))
                                  (as nil (list (Maybe Cell))))))))))))
                (cons
                  (cons (as Nothing (Maybe Cell))
                    (cons (as Nothing (Maybe Cell))
                      (cons (Just C5)
                        (cons (Just C3)
                          (cons (as Nothing (Maybe Cell))
                            (cons (Just C8)
                              (cons (Just C9)
                                (cons (as Nothing (Maybe Cell))
                                  (cons (as Nothing (Maybe Cell))
                                    (as nil (list (Maybe Cell))))))))))))
                  (cons
                    (cons (as Nothing (Maybe Cell))
                      (cons (Just C8)
                        (cons (Just C3)
                          (cons (as Nothing (Maybe Cell))
                            (cons (as Nothing (Maybe Cell))
                              (cons (as Nothing (Maybe Cell))
                                (cons (as Nothing (Maybe Cell))
                                  (cons (Just C6)
                                    (cons (as Nothing (Maybe Cell))
                                      (as nil (list (Maybe Cell))))))))))))
                    (cons
                      (cons (as Nothing (Maybe Cell))
                        (cons (as Nothing (Maybe Cell))
                          (cons (Just C7)
                            (cons (Just C6)
                              (cons (Just C9)
                                (cons (as Nothing (Maybe Cell))
                                  (cons (as Nothing (Maybe Cell))
                                    (cons (Just C4)
                                      (cons (Just C3) (as nil (list (Maybe Cell))))))))))))
                      (as nil (list (list (Maybe Cell))))))))))))))
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
  isSudoku2
    ((x (list (list (Maybe Cell))))) (list Bool)
    (match x
      (case nil (as nil (list Bool)))
      (case (cons y z) (cons (equal (length y) n9) (isSudoku2 z)))))
(define-fun
  eqCell
    ((x Cell) (y Cell)) Bool
    (match x
      (case C1
        (match y
          (case default false)
          (case C1 true)))
      (case C2
        (match y
          (case default false)
          (case C2 true)))
      (case C3
        (match y
          (case default false)
          (case C3 true)))
      (case C4
        (match y
          (case default false)
          (case C4 true)))
      (case C5
        (match y
          (case default false)
          (case C5 true)))
      (case C6
        (match y
          (case default false)
          (case C6 true)))
      (case C7
        (match y
          (case default false)
          (case C7 true)))
      (case C8
        (match y
          (case default false)
          (case C8 true)))
      (case C9
        (match y
          (case default false)
          (case C9 true)))))
(define-funs-rec
  ((isSolutionOf3
      ((x (list (Pair (list (Maybe Cell)) (list (Maybe Cell)))))
       (y (list (Pair (Maybe Cell) (Maybe Cell)))))
      (list Bool))
   (isSolutionOf2
      ((x (list (Pair (list (Maybe Cell)) (list (Maybe Cell))))))
      (list Bool)))
  ((match y
     (case nil (isSolutionOf2 x))
     (case (cons z x2)
       (let ((x3 (isSolutionOf3 x x2)))
         (match z
           (case (Pair2 x4 x5)
             (match x4
               (case Nothing x3)
               (case (Just n1)
                 (match x5
                   (case Nothing x3)
                   (case (Just n2) (cons (eqCell n1 n2) (isSolutionOf3 x x2)))))))))))
   (match x
     (case nil (as nil (list Bool)))
     (case (cons y z)
       (match y
         (case (Pair2 row1 row2) (isSolutionOf3 z (zip row1 row2))))))))
(define-fun-rec
  elem
    ((x Cell) (y (list Cell))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (eqCell x z) (elem x ys)))))
(define-fun-rec
  unique
    ((x (list Cell))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (not (elem y xs)) (unique xs)))))
(define-fun
  isOkayBlock
    ((x (list (Maybe Cell)))) Bool (unique (isOkayBlock2 x)))
(define-fun-rec
  isOkay2
    ((x (list (list (Maybe Cell))))) (list Bool)
    (match x
      (case nil (as nil (list Bool)))
      (case (cons y z) (cons (isOkayBlock y) (isOkay2 z)))))
(define-fun-rec
  (par (a)
    (drop
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (as nil (list a)))
             (case (cons x2 x3) (drop z x3))))))))
(define-fun-rec
  blocks3x34
    ((x (list (list (Maybe Cell))))) (list (list (Maybe Cell)))
    (match x
      (case nil (as nil (list (list (Maybe Cell)))))
      (case (cons y z) (cons (drop n6 y) (blocks3x34 z)))))
(define-fun-rec
  blocks3x33
    ((x (list (list (Maybe Cell))))) (list (list (Maybe Cell)))
    (match x
      (case nil (as nil (list (list (Maybe Cell)))))
      (case (cons y z) (cons (take n3 (drop n3 y)) (blocks3x33 z)))))
(define-fun-rec
  blocks3x32
    ((x (list (list (Maybe Cell))))) (list (list (Maybe Cell)))
    (match x
      (case nil (as nil (list (list (Maybe Cell)))))
      (case (cons y z) (cons (take n3 y) (blocks3x32 z)))))
(define-fun-rec
  blocks2
    ((x (list (list (Maybe Cell))))) (list (list (Maybe Cell)))
    (match x
      (case nil (as nil (list (list (Maybe Cell)))))
      (case (cons y z) (cons y (blocks2 z)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a)
    (group3
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons xs1 y)
           (match y
             (case nil (as nil (list (list a))))
             (case (cons xs2 z)
               (match z
                 (case nil (as nil (list (list a))))
                 (case (cons xs3 xss)
                   (cons (append (append xs1 xs2) xs3) (group3 xss)))))))))))
(define-fun
  blocks3x3
    ((x (list (list (Maybe Cell))))) (list (list (Maybe Cell)))
    (append (append (group3 (blocks3x32 x)) (group3 (blocks3x33 x)))
      (group3 (blocks3x34 x))))
(define-fun
  blocks
    ((x (list (list (Maybe Cell))))) (list (list (Maybe Cell)))
    (append (append (blocks2 x) (blocks2 (transpose x)))
      (blocks3x3 x)))
(define-fun-rec
  and2
    ((x (list Bool))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and y (and2 xs)))))
(define-fun
  isOkay
    ((x (list (list (Maybe Cell))))) Bool (and2 (isOkay2 (blocks x))))
(define-fun
  isSolved
    ((x (list (list (Maybe Cell))))) Bool (and2 (isSolved2 x)))
(define-fun
  isSolutionOf
    ((x (list (list (Maybe Cell)))) (y (list (list (Maybe Cell)))))
    Bool
    (and (isSolved x)
      (and (isOkay x) (and2 (isSolutionOf2 (zip x y))))))
(define-fun
  isSudoku
    ((x (list (list (Maybe Cell))))) Bool
    (and (equal (length x) n9) (and2 (isSudoku2 x))))
(assert-not
  (forall ((s (list (list (Maybe Cell)))))
    (or (not (isSudoku s)) (not (isSolutionOf s example)))))
(check-sat)
