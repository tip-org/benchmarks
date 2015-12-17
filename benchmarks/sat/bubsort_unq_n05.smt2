(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
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
  (forall ((xs (list Int)) (ys (list Int)))
    (or (distinct (bubsort xs) (bubsort ys))
      (or (= xs ys)
        (or (not (zunique xs))
          (or (distinct (length xs) (S (S (S (S (S Z))))))
            (distinct (length ys) (S (S (S (S (S Z))))))))))))
(check-sat)
