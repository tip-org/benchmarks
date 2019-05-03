(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  merge
  ((x (list Int)) (y (list Int))) (list Int)
  (match x
    ((nil y)
     ((cons z xs)
      (match y
        ((nil x)
         ((cons y2 ys)
          (ite (<= z y2) (cons z (merge xs y)) (cons y2 (merge x ys))))))))))
(prove
  (forall ((xs (list Int)) (ys (list Int)) (zs (list Int)))
    (=> (= (merge xs ys) (merge ys xs))
      (=> (= (merge xs zs) (merge zs xs))
        (= (merge ys zs) (merge zs ys))))))
