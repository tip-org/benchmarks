; Bubble sort
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (ordered-ordered1 :let :source SortUtils.ordered
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z)
           (match z
             (case nil true)
             (case (cons y2 xs) (and (<= y y2) (ordered-ordered1 z)))))))))
(define-fun-rec
  (par (a)
    (bubble :source Sort.bubble
       ((x (list a))) (pair Bool (list a))
       (match x
         (case nil (pair2 false (as nil (list a))))
         (case (cons y z)
           (match z
             (case nil (pair2 false (cons y (as nil (list a)))))
             (case (cons y2 xs)
               (ite
                 (<= y y2)
                 (match (bubble z)
                   (case (pair2 b22 ys22) (pair2 b22 (cons y ys22))))
                 (match (bubble (cons y xs))
                   (case (pair2 b23 ys2) (pair2 true (cons y2 ys2))))))))))))
(define-fun-rec
  (par (a)
    (bubsort :source Sort.bubsort
       ((x (list a))) (list a)
       (match (bubble x) (case (pair2 b1 ys) (ite b1 (bubsort ys) x))))))
(prove
  :source Sort.prop_BubSortSorts
  (forall ((x (list Int))) (ordered-ordered1 (bubsort x))))
