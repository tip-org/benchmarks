; Bottom-up merge sort, using a total risers function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zcount
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (zcount x xs)) (zcount x xs)))))
(define-fun-rec
  risers
    ((x (list Int))) (list (list Int))
    (match x
      (case nil (as nil (list (list Int))))
      (case (cons y z)
        (match z
          (case nil
            (cons (cons y (as nil (list Int))) (as nil (list (list Int)))))
          (case (cons y2 xs)
            (ite
              (<= y y2)
              (match (risers z)
                (case nil (as nil (list (list Int))))
                (case (cons ys yss) (cons (cons y ys) yss)))
              (cons (cons y (as nil (list Int))) (risers z))))))))
(define-fun-rec
  lmerge
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (ite (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))
(define-fun-rec
  pairwise
    ((x (list (list Int)))) (list (list Int))
    (match x
      (case nil (as nil (list (list Int))))
      (case (cons xs y)
        (match y
          (case nil (cons xs (as nil (list (list Int)))))
          (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))
(define-fun-rec
  mergingbu2
    ((x (list (list Int)))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu2 (pairwise x)))))))
(define-fun
  msortbu2 ((x (list Int))) (list Int) (mergingbu2 (risers x)))
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (zcount x (msortbu2 y)) (zcount x y))))
(check-sat)
