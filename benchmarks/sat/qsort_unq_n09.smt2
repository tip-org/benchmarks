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
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  filter_le
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys)
        (ite (<= z x) (cons z (filter_le x ys)) (filter_le x ys)))))
(define-fun-rec
  filter_gt
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (as nil (list Int)))
      (case (cons z ys)
        (ite (> z x) (cons z (filter_gt x ys)) (filter_gt x ys)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  qsort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y xs)
        (append
          (append (qsort (filter_le y xs)) (cons y (as nil (list Int))))
          (qsort (filter_gt y xs))))))
(assert-not
  (forall ((xs (list Int)) (ys (list Int)))
    (or (distinct (qsort xs) (qsort ys))
      (or (= xs ys)
        (or (not (zunique xs))
          (or (distinct (length xs) (S (S (S (S (S (S (S (S (S Z))))))))))
            (distinct (length ys) (S (S (S (S (S (S (S (S (S Z))))))))))))))))
(check-sat)
