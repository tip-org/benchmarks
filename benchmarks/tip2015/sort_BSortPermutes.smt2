; Bitonic sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun
  sort2
    ((x Int) (y Int)) (list Int)
    (ite
      (<= x y) (cons x (cons y (_ nil Int)))
      (cons y (cons x (_ nil Int)))))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil (_ nil a))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (_ nil a))
     (case (cons y xs) (evens xs)))))
(define-fun-rec
  (par (a)
    (elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (_ nil a))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  (par (a)
    (isPermutation
       ((x (list a)) (y (list a))) Bool
       (match x
         (case nil
           (match y
             (case nil true)
             (case (cons z x2) false)))
         (case (cons x3 xs)
           (and (elem x3 y)
             (isPermutation xs
               (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5)))
                 x3 y))))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  pairs
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4) (++ (sort2 z x3) (pairs x2 x4)))))))
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
      (case nil (_ nil Int))
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (let
              ((fail
                  (stitch (bmerge (evens x) (evens y)) (bmerge (odds x) (odds y)))))
              (match x2
                (case nil
                  (match x4
                    (case nil (sort2 z x3))
                    (case (cons x5 x6) fail)))
                (case (cons x7 x8) fail))))))))
(define-fun-rec
  bsort
    ((x (list Int))) (list Int)
    (match x
      (case nil (_ nil Int))
      (case (cons y z)
        (match z
          (case nil (cons y (_ nil Int)))
          (case (cons x2 x3) (bmerge (bsort (evens x)) (bsort (odds x))))))))
(prove (forall ((xs (list Int))) (isPermutation (bsort xs) xs)))
