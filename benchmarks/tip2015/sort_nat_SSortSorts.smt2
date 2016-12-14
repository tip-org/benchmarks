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
    (deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (as nil (list a)))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
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
(assert-not (forall ((x (list Nat))) (ordered-ordered1 (ssort x))))
(check-sat)
