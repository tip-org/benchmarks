(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (t t2) (x ((f (=> t2 t)) (y (list t2))) (list t))))
  ((match y
     (case nil (as nil (list t)))
     (case (cons z x2) (cons (@ f z) (x f x2))))))
(define-funs-rec ((or2 ((y bool) (z bool)) bool)) ((ite y true z)))
(define-funs-rec
  ((par (t) (null ((y (list t))) bool)))
  ((match y
     (case nil true)
     (case (cons z x2) false))))
(define-funs-rec
  ((lmerge ((y (list int)) (z (list int))) (list int)))
  ((match y
     (case nil z)
     (case (cons x2 x3)
       (match z
         (case nil y)
         (case (cons x4 x5)
           (ite
             (<= x2 x4) (cons x2 (lmerge x3 z)) (cons x4 (lmerge y x5)))))))))
(define-funs-rec
  ((pairwise ((y (list (list int)))) (list (list int))))
  ((match y
     (case nil y)
     (case (cons xs z)
       (match z
         (case nil y)
         (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss))))))))
(define-funs-rec
  ((mergingbu ((y (list (list int)))) (list int)))
  ((match y
     (case nil (as nil (list int)))
     (case (cons xs z)
       (match z
         (case nil xs)
         (case (cons x2 x3) (mergingbu (pairwise y))))))))
(define-funs-rec
  ((elem ((y int) (z (list int))) bool))
  ((match z
     (case nil false)
     (case (cons y2 ys) (or2 (= y y2) (elem y ys))))))
(define-funs-rec
  ((par (b c a) (dot ((y (=> b c)) (z (=> a b)) (x2 a)) c)))
  ((@ y (@ z x2))))
(define-funs-rec
  ((msortbu ((y (list int))) (list int)))
  ((dot (lambda ((z (list (list int)))) (mergingbu z))
     (lambda ((x2 (list int)))
       (x (lambda ((x3 int)) (cons x3 (as nil (list int)))) x2))
     y)))
(define-funs-rec
  ((delete ((y int) (z (list int))) (list int)))
  ((match z
     (case nil z)
     (case (cons y2 ys) (ite (= y y2) ys (cons y2 (delete y ys)))))))
(define-funs-rec
  ((and2 ((y bool) (z bool)) bool)) ((ite y z false)))
(define-funs-rec
  ((isPermutation ((y (list int)) (z (list int))) bool))
  ((match y
     (case nil (null z))
     (case (cons x2 xs)
       (and2 (elem x2 z) (isPermutation xs (delete x2 z)))))))
(assert-not
  (forall ((y (list int))) (isPermutation (msortbu y) y)))
(check-sat)
