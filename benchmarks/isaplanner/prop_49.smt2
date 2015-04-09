; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par
     (a3)
     (butlast
        ((x3 (list a3))) (list a3)
        (match x3
          (case nil x3)
          (case
            (cons x4 ds)
            (match ds
              (case nil ds)
              (case
                (cons ipv3 ipv4) (cons x4 (as (butlast ds) (list a3)))))))))))
(define-funs-rec
  ((par
     (a4)
     (append
        ((x5 (list a4)) (x6 (list a4))) (list a4)
        (match x5
          (case nil x6)
          (case (cons x7 xs) (cons x7 (as (append xs x6) (list a4)))))))))
(define-funs-rec
  ((par
     (a2)
     (butlastConcat
        ((x (list a2)) (x2 (list a2))) (list a2)
        (match x2
          (case nil (butlast x))
          (case (cons ipv ipv2) (append x (butlast x2))))))))
(declare-sort a5 0)
(assert
  (not
    (forall
      ((xs2 (list a5)) (ys (list a5)))
      (= (butlast (append xs2 ys)) (butlastConcat xs2 ys)))))
(check-sat)
