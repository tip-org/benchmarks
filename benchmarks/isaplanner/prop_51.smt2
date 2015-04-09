; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a2) (butlast ((x (list a2))) (list a2))))
  ((match x
     (case nil x)
     (case
       (cons x2 ds)
       (match ds
         (case nil ds)
         (case (cons ipv ipv2) (cons x2 (as (butlast ds) (list a2)))))))))
(define-funs-rec
  ((par (a3) (append ((x3 (list a3)) (x4 (list a3))) (list a3))))
  ((match x3
     (case nil x4)
     (case (cons x5 xs) (cons x5 (as (append xs x4) (list a3)))))))
(declare-sort a4 0)
(assert
  (not
    (forall
      ((xs2 (list a4)) (x6 a4))
      (= (butlast (append xs2 (cons x6 (as nil (list a4))))) xs2))))
(check-sat)
