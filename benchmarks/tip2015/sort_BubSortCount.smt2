; Bubble sort
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
(define-fun-rec
  bubble
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
                (case (pair2 b12 ys12) (pair2 b12 (cons y ys12))))
              (match (bubble (cons y xs))
                (case (pair2 b1 ys1) (pair2 true (cons y2 ys1))))))))))
(define-fun-rec
  bubsort
    ((x (list Int))) (list Int)
    (match (bubble x) (case (pair2 c ys1) (ite c (bubsort ys1) x))))
(prove
  (forall ((x Int) (xs (list Int)))
    (= (count x (bubsort xs)) (count x xs))))
