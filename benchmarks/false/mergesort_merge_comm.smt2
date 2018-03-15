(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  merge :source Mergesort.merge
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z xs)
        (match y
          (case nil x)
          (case (cons y2 ys)
            (ite (<= z y2) (cons z (merge xs y)) (cons y2 (merge x ys))))))))
(prove
  :source Mergesort.prop_merge_comm
  (forall ((xs (list Int)) (ys (list Int)) (zs (list Int)))
    (=> (= (merge xs ys) (merge ys xs))
      (=> (= (merge xs zs) (merge zs xs))
        (= (merge ys zs) (merge zs ys))))))
