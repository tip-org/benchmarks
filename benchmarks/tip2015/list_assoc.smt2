; List monad laws
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a3) (append ((x4 (list a3)) (x5 (list a3))) (list a3))))
  ((match x4
     (case nil x5)
     (case (cons x6 xs2) (cons x6 (as (append xs2 x5) (list a3)))))))
(define-funs-rec
  ((par
     (a2 b) (bind ((x (list a2)) (x2 (=> a2 (list b)))) (list b))))
  ((match x
     (case nil (as nil (list b)))
     (case
       (cons x3 xs) (append (@ x2 x3) (as (bind xs x2) (list b)))))))
(assert-not
  (par
    (a4 b2 c)
    (forall
      ((m (list a4)) (f (=> a4 (list b2))) (g (=> b2 (list c))))
      (=
        (bind (bind m f) g)
        (bind m (lambda ((x7 a4)) (bind (@ f x7) g)))))))
(check-sat)
