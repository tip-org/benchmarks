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
  (forall ((x Int) (y (list Int)))
    (= (zcount x (bubsort y)) (zcount x y))))
(check-sat)
