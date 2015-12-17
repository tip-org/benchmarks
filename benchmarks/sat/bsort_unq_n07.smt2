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
(define-fun
  sort2
    ((x Int) (y Int)) (list Int)
    (ite
      (<= x y) (cons x (cons y (as nil (list Int))))
      (cons y (cons x (as nil (list Int))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (as nil (list a)))
     (case (cons y xs) (evens xs)))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  pairs
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4) (append (sort2 z x3) (pairs x2 x4)))))))
(define-fun
  stitch
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z xs) (cons z (pairs xs y)))))
(define-fun-rec
  bmerge
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (let
              ((x5
                  (stitch (bmerge (evens x) (evens y)) (bmerge (odds x) (odds y)))))
              (match x2
                (case nil
                  (match x4
                    (case nil (sort2 z x3))
                    (case (cons x6 x7) x5)))
                (case (cons x8 x9) x5))))))))
(define-fun-rec
  bsort
    ((x (list Int))) (list Int)
    (match x
      (case nil (as nil (list Int)))
      (case (cons y z)
        (match z
          (case nil (cons y (as nil (list Int))))
          (case (cons x2 x3) (bmerge (bsort (evens x)) (bsort (odds x))))))))
(assert-not
  (forall ((xs (list Int)) (ys (list Int)))
    (or (distinct (bsort xs) (bsort ys))
      (or (= xs ys)
        (or (not (zunique xs))
          (or (distinct (length xs) (S (S (S (S (S (S (S Z))))))))
            (distinct (length ys) (S (S (S (S (S (S (S Z))))))))))))))
(check-sat)
