(define-fun-rec
  m ((x Int)) Int (ite (> x 100) (- x 10) (m (m (+ x 11)))))
(prove (forall ((n Int)) (=> (>= n 101) (= (m n) (- n 10)))))
