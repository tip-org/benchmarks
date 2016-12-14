; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (ssort-minimum1
       ((x a) (y (list a))) a
       (match y
         (case nil x)
         (case (cons y1 ys1)
           (ite (<= y1 x) (ssort-minimum1 y1 ys1) (ssort-minimum1 x ys1)))))))
(define-fun-rec
  (par (a)
    (elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (as nil (list a)))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  (par (a)
    (isPermutation
       ((x (list a)) (y (list a))) Bool
       (match x
         (case nil
           (match y
             (case nil true)
             (case (cons z x2) false)))
         (case (cons x3 xs)
           (and (elem x3 y)
             (isPermutation xs
               (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5)))
                 x3 y))))))))
(define-fun-rec
  (par (a)
    (ssort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y ys)
           (let ((m (ssort-minimum1 y ys)))
             (cons m
               (ssort
                 (deleteBy (lambda ((z a)) (lambda ((x2 a)) (= z x2))) m x)))))))))
(assert-not (forall ((x (list Nat))) (isPermutation (ssort x) x)))
(check-sat)
