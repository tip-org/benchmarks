(define-funs-rec
  ((m ((x Int)) Int)) ((ite (> x 100) (- x 10) (m (m (+ x 11))))))
(assert-not (forall ((n Int)) (=> (<= n 100) (= (m n) 91))))
(check-sat)
