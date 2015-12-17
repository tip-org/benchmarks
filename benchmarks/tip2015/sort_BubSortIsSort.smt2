; Bubble sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-fun-rec
  insert2
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (cons x (as nil (list Int))))
      (case (cons z xs)
        (ite (<= x z) (cons x y) (cons z (insert2 x xs))))))
(define-fun-rec
  isort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y xs) (insert2 y (isort xs)))))
(define-fun-rec
  bubble
    ((x (list Int))) (Pair Bool (list Int))
    (let ((y (Pair2 false x)))
      (match x
        (case nil y)
        (case (cons z x2)
          (match x2
            (case nil y)
            (case (cons y2 xs)
              (ite
                (<= z y2)
                (match (bubble x2) (case (Pair2 b2 zs) (Pair2 b2 (cons z zs))))
                (match (bubble (cons z xs))
                  (case (Pair2 c ys) (Pair2 true (cons y2 ys)))))))))))
(define-fun-rec
  bubsort
    ((x (list Int))) (list Int)
    (match (bubble x) (case (Pair2 c ys) (ite c (bubsort ys) x))))
(assert-not (forall ((x (list Int))) (= (bubsort x) (isort x))))
(check-sat)
