(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a)
  ((Heap (Node (Node_0 (Heap a)) (Node_1 a) (Node_2 (Heap a)))
     (Nil))))
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
  toHeap2
    ((x (list Int))) (list (Heap Int))
    (match x
      (case nil (as nil (list (Heap Int))))
      (case (cons y z)
        (cons (Node (as Nil (Heap Int)) y (as Nil (Heap Int)))
          (toHeap2 z)))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  hmerge
    ((x (Heap Int)) (y (Heap Int))) (Heap Int)
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (<= x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  hpairwise
    ((x (list (Heap Int)))) (list (Heap Int))
    (match x
      (case nil (as nil (list (Heap Int))))
      (case (cons q y)
        (match y
          (case nil (cons q (as nil (list (Heap Int)))))
          (case (cons r qs) (cons (hmerge q r) (hpairwise qs)))))))
(define-fun-rec
  hmerging
    ((x (list (Heap Int)))) (Heap Int)
    (match x
      (case nil (as Nil (Heap Int)))
      (case (cons q y)
        (match y
          (case nil q)
          (case (cons z x2) (hmerging (hpairwise x)))))))
(define-fun
  toHeap ((x (list Int))) (Heap Int) (hmerging (toHeap2 x)))
(define-fun-rec
  toList
    ((x (Heap Int))) (list Int)
    (match x
      (case (Node q y r) (cons y (toList (hmerge q r))))
      (case Nil (as nil (list Int)))))
(define-fun hsort ((x (list Int))) (list Int) (toList (toHeap x)))
(assert-not
  (forall ((xs (list Int)) (ys (list Int)))
    (or (distinct (hsort xs) (hsort ys))
      (or (= xs ys)
        (or (not (zunique xs))
          (or
            (distinct (length xs) (S (S (S (S (S (S (S (S (S (S Z)))))))))))
            (distinct (length ys)
              (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))
(check-sat)
