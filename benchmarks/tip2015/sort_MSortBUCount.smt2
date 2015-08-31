; Bottom-up merge sort
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
  (par (a b)
    (map2
       ((x (=> a b)) (y (list a))) (list b)
       (match y
         (case nil (as nil (list b)))
         (case (cons z xs) (cons (@ x z) (map2 x xs)))))))
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
  mergingbu
    ((x (list (list Int)))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu (pairwise x)))))))
(define-fun
  msortbu
    ((x (list Int))) (list Int)
    (mergingbu
      (map2 (lambda ((y Int)) (cons y (as nil (list Int)))) x)))
(assert-not
  (forall ((x Int) (y (list Int)))
    (= (zcount x (msortbu y)) (zcount x y))))
(check-sat)
