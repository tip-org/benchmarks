; Bubble sort
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  ordered :source SortUtils.ordered
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (<= y y2) (ordered z)))))))
(define-fun-rec
  bubble :source Sort.bubble
    ((x (list Int))) (pair Bool (list Int))
    (match x
      (case nil (pair2 false (_ nil Int)))
      (case (cons y z)
        (match z
          (case nil (pair2 false (cons y (_ nil Int))))
          (case (cons y2 xs)
            (ite
              (<= y y2)
              (match (bubble z)
                (case (pair2 b22 ys22) (pair2 b22 (cons y ys22))))
              (match (bubble (cons y xs))
                (case (pair2 b2 ys2) (pair2 true (cons y2 ys2))))))))))
(define-fun-rec
  bubsort :source Sort.bubsort
    ((x (list Int))) (list Int)
    (match (bubble x) (case (pair2 b1 ys) (ite b1 (bubsort ys) x))))
(prove
  :source Sort.prop_BubSortSorts
  (forall ((xs (list Int))) (ordered (bubsort xs))))
