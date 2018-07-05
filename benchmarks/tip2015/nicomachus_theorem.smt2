; Nicomachus' theorem
(define-fun-rec
  sum ((x Int)) Int (ite (= x 0) 0 (+ (sum (- x 1)) x)))
(define-fun-rec
  cubes
    ((x Int)) Int (ite (= x 0) 0 (+ (cubes (- x 1)) (* (* x x) x))))
(prove (forall ((n Int)) (= (cubes n) (* (sum n) (sum n)))))
