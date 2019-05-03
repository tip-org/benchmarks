; Selection sort, using a total minimum function
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  ssort-minimum1
  ((x Int) (y (list Int))) Int
  (match y
    ((nil x)
     ((cons y1 ys1)
      (ite (<= y1 x) (ssort-minimum1 y1 ys1) (ssort-minimum1 x ys1))))))
(define-fun-rec
  deleteBy
  (par (a) (((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)))
  (match z
    ((nil (_ nil a))
     ((cons y2 ys)
      (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys)))))))
(define-fun-rec
  ssort
  ((x (list Int))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons y ys)
      (let ((m (ssort-minimum1 y ys)))
        (cons m
          (ssort
            (deleteBy (lambda ((z Int)) (lambda ((x2 Int)) (= z x2)))
              m x))))))))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Int))
  (match y
    ((nil 0)
     ((cons z ys) (ite (= x z) (+ 1 (count x ys)) (count x ys))))))
(prove
  (forall ((x Int) (xs (list Int)))
    (= (count x (ssort xs)) (count x xs))))
