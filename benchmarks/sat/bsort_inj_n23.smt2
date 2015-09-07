(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun
  sort2
    ((x Nat) (y Nat)) (list Nat)
    (ite
      (le x y) (cons x (cons y (as nil (list Nat))))
      (cons y (cons x (as nil (list Nat))))))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (as nil (list a)))
     (case (cons y xs) (evens xs)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  pairs
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4) (append (sort2 z x3) (pairs x2 x4)))))))
(define-fun
  stitch
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil y)
      (case (cons z xs) (cons z (pairs xs y)))))
(define-fun-rec
  bmerge
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (match x2
              (case nil
                (match x4
                  (case nil (sort2 z x3))
                  (case (cons x5 x6)
                    (stitch (bmerge (evens (cons z (as nil (list Nat)))) (evens y))
                      (bmerge (odds (cons z (as nil (list Nat)))) (odds y))))))
              (case (cons x7 x8)
                (stitch (bmerge (evens x) (evens y))
                  (bmerge (odds x) (odds y))))))))))
(define-fun-rec
  bsort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (as nil (list Nat)))
      (case (cons y z)
        (match z
          (case nil (cons y (as nil (list Nat))))
          (case (cons x2 x3) (bmerge (bsort (evens x)) (bsort (odds x))))))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (bsort xs) (bsort ys))
      (or (= xs ys)
        (distinct (length xs)
          (S
            (S
              (S
                (S
                  (S
                    (S
                      (S
                        (S
                          (S
                            (S
                              (S
                                (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))))))
(check-sat)
