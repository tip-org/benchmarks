(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (transpose2
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y z)
           (match y
             (case nil (transpose2 z))
             (case (cons h x2) (cons h (transpose2 z)))))))))
(define-fun-rec
  (par (a)
    (reverse_go
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z ys) (reverse_go ys (cons z y)))))))
(define-fun
  (par (a)
    (reverse
       ((x (list a))) (list a) (reverse_go x (as nil (list a))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun-rec
  (par (a)
    (isMatrix2
       ((n Nat) (x (list (list a)))) (list Bool)
       (match x
         (case nil (as nil (list Bool)))
         (case (cons y z) (cons (equal (length y) n) (isMatrix2 n z)))))))
(define-fun-rec
  empty
    ((x (list Bool))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (not y) (empty xs)))))
(define-fun-rec
  ok
    ((x (list Bool))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (ite y (empty xs) (ok xs)))))
(define-fun-rec
  nq2
    ((x (list (list Bool)))) (list Bool)
    (match x
      (case nil (as nil (list Bool)))
      (case (cons y z) (cons (ok y) (nq2 z)))))
(define-fun
  (par (t)
    (dropH
       ((x (list t))) (list t)
       (match x
         (case nil (as nil (list t)))
         (case (cons y xs) xs)))))
(define-fun-rec
  (par (a)
    (drop1
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons y z)
           (match y
             (case nil (drop1 z))
             (case (cons x2 t) (cons t (drop1 z)))))))))
(define-fun-rec
  (par (a)
    (transpose
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons y xss)
           (match y
             (case nil (transpose xss))
             (case (cons z xs)
               (cons (cons z (transpose2 xss))
                 (transpose (cons xs (drop1 xss)))))))))))
(define-fun-rec
  (par (a)
    (diag
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xss)
           (match y
             (case nil (as nil (list a)))
             (case (cons z x2) (cons z (diag (drop1 xss))))))))))
(define-fun-rec
  (par (a)
    (lowerdiags
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons y r) (cons (diag x) (lowerdiags r)))))))
(define-fun-rec
  count
    ((x (list Bool))) Nat
    (match x
      (case nil Z)
      (case (cons y xs) (ite y (S (count xs)) (count xs)))))
(define-fun-rec
  (par (a)
    (bothdiags2
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons y z) (cons (reverse y) (bothdiags2 z)))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a)
    (concat2
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons xs xss) (append xs (concat2 xss)))))))
(define-fun
  (par (a)
    (diags
       ((x (list (list a)))) (list (list a))
       (append (lowerdiags x) (dropH (lowerdiags (transpose x)))))))
(define-fun
  (par (a)
    (bothdiags
       ((x (list (list a)))) (list (list a))
       (append (diags x) (diags (bothdiags2 x))))))
(define-fun-rec
  and2
    ((x (list Bool))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and y (and2 xs)))))
(define-fun
  (par (a)
    (isMatrix
       ((x Nat) (y (list (list a)))) Bool
       (and (equal (length y) x) (and2 (isMatrix2 x y))))))
(define-fun
  nq
    ((x (list (list Bool)))) Bool
    (and (and2 (nq2 x))
      (and (and2 (nq2 (transpose x))) (and2 (nq2 (bothdiags x))))))
(assert-not
  (forall ((xs (list (list Bool))))
    (or (not (isMatrix (S (S (S (S (S Z))))) xs))
      (or (not (nq xs))
        (not (equal (count (concat2 xs)) (S (S (S (S (S Z)))))))))))
(check-sat)
