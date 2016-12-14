; Bottom-up merge sort, using a total risers function
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (risers
       ((x (list a))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons y z)
           (match z
             (case nil
               (cons (cons y (as nil (list a))) (as nil (list (list a)))))
             (case (cons y2 xs)
               (ite
                 (<= y y2)
                 (match (risers z)
                   (case nil (as nil (list (list a))))
                   (case (cons ys yss) (cons (cons y ys) yss)))
                 (cons (cons y (as nil (list a))) (risers z))))))))))
(define-fun-rec
  (par (a)
    (ordered-ordered1
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z)
           (match z
             (case nil true)
             (case (cons y2 xs) (and (<= y y2) (ordered-ordered1 z)))))))))
(define-fun-rec
  (par (a)
    (lmerge
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z x2)
           (match y
             (case nil x)
             (case (cons x3 x4)
               (ite
                 (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  (par (a)
    (pairwise-pairwise1
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons xs y)
           (match y
             (case nil (cons xs (as nil (list (list a)))))
             (case (cons ys xss)
               (cons (lmerge xs ys) (pairwise-pairwise1 xss)))))))))
(define-fun-rec
  (par (a)
    (mergingbu2
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons xs y)
           (match y
             (case nil xs)
             (case (cons z x2) (mergingbu2 (pairwise-pairwise1 x)))))))))
(define-fun
  (par (a)
    (msortbu2 ((x (list a))) (list a) (mergingbu2 (risers x)))))
(assert-not
  (forall ((x (list Nat))) (ordered-ordered1 (msortbu2 x))))
(check-sat)
