; Top-down merge sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (ztake
       ((x Int) (y (list a))) (list a)
       (ite
         (= x 0) (as nil (list a))
         (match y
           (case nil (as nil (list a)))
           (case (cons z xs) (cons z (ztake (- x 1) xs))))))))
(define-fun-rec
  zordered
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (<= y y2) (zordered z)))))))
(define-fun-rec
  (par (a)
    (zlength
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y xs) (+ 1 (zlength xs)))))))
(define-fun-rec
  (par (a)
    (zdrop
       ((x Int) (y (list a))) (list a)
       (ite
         (= x 0) y
         (match y
           (case nil (as nil (list a)))
           (case (cons z xs1) (zdrop (- x 1) xs1)))))))
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
  msorttd
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y z)
        (match z
          (case nil (cons y (as nil (list Int))))
          (case (cons x2 x3)
            (let ((k (div (zlength x) 2)))
              (lmerge (msorttd (ztake k x)) (msorttd (zdrop k x)))))))))
(assert-not (forall ((x (list Int))) (zordered (msorttd x))))
(check-sat)
