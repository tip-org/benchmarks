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
  (par (a)
    (bubble
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
    (bubsort
       ((x (list a))) (list a)
       (match (bubble x) (case (pair2 b1 ys) (ite b1 (bubsort ys) x))))))
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (count x (bubsort y)) (count x y))))
(check-sat)
