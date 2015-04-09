; List monad laws
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par
     (a2)
     (weird_concat
        ((x (list (list a2)))) (list a2)
        (match x
          (case nil (as nil (list a2)))
          (case
            (cons ds xss)
            (match ds
              (case nil (as (weird_concat xss) (list a2)))
              (case
                (cons x2 xs)
                (cons x2 (as (weird_concat (cons xs xss)) (list a2)))))))))))
(define-funs-rec
  ((par
     (a3 b)
     (fmap
        ((x3 (=> a3 b)) (x4 (list a3))) (list b)
        (match x4
          (case nil (as nil (list b)))
          (case
            (cons x5 xs2) (cons (@ x3 x5) (as (fmap x3 xs2) (list b)))))))))
(define-funs-rec
  ((par
     (a5)
     (append
        ((x9 (list a5)) (x10 (list a5))) (list a5)
        (match x9
          (case nil x10)
          (case
            (cons x11 xs4) (cons x11 (as (append xs4 x10) (list a5)))))))))
(define-funs-rec
  ((par
     (a4 b2)
     (bind
        ((x6 (list a4)) (x7 (=> a4 (list b2)))) (list b2)
        (match x6
          (case nil (as nil (list b2)))
          (case
            (cons x8 xs3) (append (@ x7 x8) (as (bind xs3 x7) (list b2)))))))))
(declare-sort a6 0)
(declare-sort b3 0)
(assert
  (not
    (forall
      ((f (=> a6 (list b3))) (xs5 (list a6)))
      (= (weird_concat (fmap f xs5)) (bind xs5 f)))))
(check-sat)
