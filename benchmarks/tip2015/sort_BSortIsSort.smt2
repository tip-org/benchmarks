; Bitonic sort
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun
  sort2
  ((x Int) (y Int)) (list Int)
  (ite
    (<= x y) (cons x (cons y (_ nil Int)))
    (cons y (cons x (_ nil Int)))))
(define-fun-rec
  insert
  ((x Int) (y (list Int))) (list Int)
  (match y
    ((nil (cons x (_ nil Int)))
     ((cons z xs) (ite (<= x z) (cons x y) (cons z (insert x xs)))))))
(define-fun-rec
  isort
  ((x (list Int))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons y xs) (insert y (isort xs))))))
(define-funs-rec
  ((evens
    (par (a) (((x (list a))) (list a))))
   (odds
    (par (a) (((x (list a))) (list a)))))
  ((match x
     ((nil (_ nil a))
      ((cons y xs) (cons y (odds xs)))))
   (match x
     ((nil (_ nil a))
      ((cons y xs) (evens xs))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  pairs
  ((x (list Int)) (y (list Int))) (list Int)
  (match x
    ((nil y)
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4) (++ (sort2 z x3) (pairs x2 x4)))))))))
(define-fun
  stitch
  ((x (list Int)) (y (list Int))) (list Int)
  (match x
    ((nil y)
     ((cons z xs) (cons z (pairs xs y))))))
(define-fun-rec
  bmerge
  ((x (list Int)) (y (list Int))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4)
          (let
            ((fail
                (stitch (bmerge (evens x) (evens y)) (bmerge (odds x) (odds y)))))
            (match x2
              ((nil
                (match x4
                  ((nil (sort2 z x3))
                   ((cons x5 x6) fail))))
               ((cons x7 x8) fail)))))))))))
(define-fun-rec
  bsort
  ((x (list Int))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons y z)
      (match z
        ((nil (cons y (_ nil Int)))
         ((cons x2 x3) (bmerge (bsort (evens x)) (bsort (odds x))))))))))
(prove (forall ((xs (list Int))) (= (bsort xs) (isort xs))))
