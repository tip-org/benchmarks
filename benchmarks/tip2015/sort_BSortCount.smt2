; Bitonic sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun
  sort2
    ((x Int) (y Int)) (list Int)
    (ite
      (<= x y) (cons x (cons y (as nil (list Int))))
      (cons y (cons x (as nil (list Int))))))
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
  count
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  pairs
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4) (append (sort2 z x3) (pairs x2 x4)))))))
(define-fun
  stitch
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z xs) (cons z (pairs xs y)))))
(define-fun-rec
  bmerge
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (match x2
              (case nil
                (match x4
                  (case nil (sort2 z x3))
                  (case (cons x5 x6)
                    (stitch (bmerge (evens (cons z (as nil (list Int)))) (evens y))
                      (bmerge (odds (cons z (as nil (list Int)))) (odds y))))))
              (case (cons x7 x8)
                (stitch (bmerge (evens x) (evens y))
                  (bmerge (odds x) (odds y))))))))))
(define-fun-rec
  bsort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y z)
        (match z
          (case nil (cons y (as nil (list Int))))
          (case (cons x2 x3) (bmerge (bsort (evens x)) (bsort (odds x))))))))
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (count x (bsort y)) (count x y))))
(check-sat)
