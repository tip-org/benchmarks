; Bubble sort
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
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
  :source Sort.prop_BubSortCount
  (forall ((x Int) (xs (list Int)))
    (= (count x (bubsort xs)) (count x xs))))
