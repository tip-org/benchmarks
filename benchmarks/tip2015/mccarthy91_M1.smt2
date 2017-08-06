(define-fun-rec
  m :source McCarthy91.m
    ((x Int)) Int (ite (> x 100) (- x 10) (m (m (+ x 11)))))
(prove
  :source McCarthy91.prop_M1
  (forall ((n Int)) (=> (<= n 100) (= (m n) 91))))
