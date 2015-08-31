; Bubble sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zcount
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (zcount x xs)) (zcount x xs)))))
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
  (forall ((x Int) (y (list Int)))
    (= (zcount x (bubsort y)) (zcount x y))))
(check-sat)
