; Bubble sort
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  ordered
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (<= y y2) (ordered z)))))))
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
(prove (forall ((xs (list Int))) (ordered (bubsort xs))))
