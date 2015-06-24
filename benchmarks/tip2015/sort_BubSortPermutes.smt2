; Bubble sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-fun
  (par (t)
    (null
       ((x (list t))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  elem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (elem x ys)))))
(define-fun-rec
  delete
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys) (ite (= x z) ys (cons z (delete x ys))))))
(define-fun-rec
  isPermutation
    ((x (list Int)) (y (list Int))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (and (elem z y) (isPermutation xs (delete z y))))))
(define-fun-rec
  bubble
    ((x (list Int))) (Pair Bool (list Int))
    (match x
      (case nil (Pair2 false (as nil (list Int))))
      (case (cons y z)
        (match z
          (case nil (Pair2 false (cons y (as nil (list Int)))))
          (case (cons y2 xs)
            (ite
              (<= y y2)
              (match (bubble z) (case (Pair2 b2 zs) (Pair2 b2 (cons y zs))))
              (match (bubble (cons y xs))
                (case (Pair2 c ys) (Pair2 true (cons y2 ys))))))))))
(define-fun-rec
  bubsort
    ((x (list Int))) (list Int)
    (match (bubble x) (case (Pair2 c ys) (ite c (bubsort ys) x))))
(assert-not
  (forall ((x (list Int))) (isPermutation (bubsort x) x)))
(check-sat)
