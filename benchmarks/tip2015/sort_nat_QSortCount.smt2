; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  (par (a)
    (filter
       ((q (=> a Bool)) (x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs)
           (ite (@ q y) (cons y (filter q xs)) (filter q xs)))))))
(define-fun-rec
  (par (a)
    (count
       ((x a) (y (list a))) Nat
       (match y
         (case nil Z)
         (case (cons z ys)
           (ite (= x z) (plus (S Z) (count x ys)) (count x ys)))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (qsort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs)
           (++ (qsort (filter (lambda ((z a)) (<= z y)) xs))
             (++ (cons y (as nil (list a)))
               (qsort (filter (lambda ((x2 a)) (> x2 y)) xs)))))))))
(assert-not
  (forall ((x Nat) (y (list Nat)))
    (= (count x (qsort y)) (count x y))))
(check-sat)
