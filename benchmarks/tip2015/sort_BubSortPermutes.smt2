; Bubble sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
(define-fun-rec
  zdelete
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys) (ite (= x z) ys (cons z (zdelete x ys))))))
(define-fun
  (par (a)
    (null
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  zisPermutation
    ((x (list Int)) (y (list Int))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (and (zelem z y) (zisPermutation xs (zdelete z y))))))
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
(assert-not
  (forall ((x (list Int))) (zisPermutation (bubsort x) x)))
(check-sat)
