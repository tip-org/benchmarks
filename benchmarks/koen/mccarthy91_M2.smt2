(define-funs-rec
  ((m ((x int)) int)) ((ite (> x 100) (- x 10) (m (m (+ x 11))))))
(assert-not (forall ((n int)) (=> (>= n 101) (= (m n) (- n 10)))))
(check-sat)
