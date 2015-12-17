(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
(define-fun-rec
  zunique
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (not (zelem y xs)) (zunique xs)))))
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
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(assert-not
  (forall ((xs (list Int)) (ys (list Int)))
    (or (distinct (msortbu2 xs) (msortbu2 ys))
      (or (= xs ys)
        (or (not (zunique xs))
          (or (distinct (length xs) (S (S (S (S (S (S (S Z))))))))
            (distinct (length ys) (S (S (S (S (S (S (S Z))))))))))))))
(check-sat)
