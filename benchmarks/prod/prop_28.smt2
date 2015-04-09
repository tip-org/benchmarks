; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par
     (a3)
     (append
        ((x6 (list a3)) (x7 (list a3))) (list a3)
        (match x6
          (case nil x7)
          (case (cons x8 xs4) (cons x8 (as (append xs4 x7) (list a3)))))))))
(define-funs-rec
  ((par
     (a4)
     (rev
        ((x2 (list a4))) (list a4)
        (match x2
          (case nil x2)
          (case
            (cons x3 xs2)
            (append
              (as (rev xs2) (list a4)) (cons x3 (as nil (list a4))))))))))
(define-funs-rec
  ((par
     (a5)
     (qrevflat
        ((x4 (list (list a5))) (x5 (list a5))) (list a5)
        (match x4
          (case nil x5)
          (case
            (cons xs3 xss2)
            (as (qrevflat xss2 (append (rev xs3) x5)) (list a5))))))))
(define-funs-rec
  ((par
     (a2)
     (revflat
        ((x (list (list a2)))) (list a2)
        (match x
          (case nil (as nil (list a2)))
          (case (cons xs xss) (append (as (revflat xss) (list a2)) xs)))))))
(declare-sort a6 0)
(assert
  (not
    (forall
      ((x9 (list (list a6))))
      (= (revflat x9) (qrevflat x9 (as nil (list a6)))))))
(check-sat)
