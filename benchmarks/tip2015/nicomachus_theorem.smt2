; Nicomachus' theorem
(define-fun-rec
  sum :source Nicomachus.sum
    ((x Int)) Int (ite (= x 0) 0 (+ (sum (- x 1)) x)))
(define-fun-rec
  cubes :source Nicomachus.cubes
    ((x Int)) Int (ite (= x 0) 0 (+ (cubes (- x 1)) (* (* x x) x))))
(prove
  :source Nicomachus.prop_theorem
  (forall ((n Int)) (= (cubes n) (* (sum n) (sum n)))))
