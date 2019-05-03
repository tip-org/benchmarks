; Bubble sort
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  deleteBy
  (par (a) (((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)))
  (match z
    ((nil (_ nil a))
     ((cons y2 ys)
      (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys)))))))
(define-fun-rec
  isPermutation
  (par (a) (((x (list a)) (y (list a))) Bool))
  (match x
    ((nil
      (match y
        ((nil true)
         ((cons z x2) false))))
     ((cons x3 xs)
      (and (elem x3 y)
        (isPermutation xs
          (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5))) x3 y)))))))
(define-fun-rec
  bubble
  ((x (list Int))) (pair Bool (list Int))
  (match x
    ((nil (pair2 false (_ nil Int)))
     ((cons y z)
      (match z
        ((nil (pair2 false (cons y (_ nil Int))))
         ((cons y2 xs)
          (ite
            (<= y y2)
            (match (bubble z) (((pair2 b12 ys12) (pair2 b12 (cons y ys12)))))
            (match (bubble (cons y xs))
              (((pair2 b1 ys1) (pair2 true (cons y2 ys1)))))))))))))
(define-fun-rec
  bubsort
  ((x (list Int))) (list Int)
  (match (bubble x) (((pair2 c ys1) (ite c (bubsort ys1) x)))))
(prove (forall ((xs (list Int))) (isPermutation (bubsort xs) xs)))
