(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype B ((I) (O)))
(define-fun
  half
  ((x Int)) Int (div x 2))
(define-fun-rec
  shw
  ((x Int)) (list B)
  (ite
    (= x 0) (_ nil B)
    (let ((md (mod x 2)))
      (ite
        (and
          (= (ite (= x 0) 0 (ite (<= x 0) (- 0 1) 1))
            (ite (<= 2 0) (- 0 (- 0 1)) (- 0 1)))
          (distinct md 0))
        (ite
          (= (- md 2) 0) (cons O (shw (half x))) (cons I (shw (half x))))
        (ite (= md 0) (cons O (shw (half x))) (cons I (shw (half x))))))))
(define-fun
  double
  ((x Int)) Int (+ x x))
(define-fun-rec
  rd
  ((x (list B))) Int
  (match x
    ((nil 0)
     ((cons y xs)
      (match y
        ((I (+ 1 (double (rd xs))))
         (O (double (rd xs)))))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun
  |#|
  ((x Int) (y Int)) Int (rd (++ (shw x) (shw y))))
(prove
  (forall ((x Int) (y Int) (z Int))
    (= (|#| x (|#| y z)) (|#| (|#| x y) z))))
