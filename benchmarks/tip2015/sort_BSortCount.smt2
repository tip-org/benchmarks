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
    (count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
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
(prove
  (forall ((x Int) (xs (list Int)))
    (= (count x (bsort xs)) (count x xs))))
