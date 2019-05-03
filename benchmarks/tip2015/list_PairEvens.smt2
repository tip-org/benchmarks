(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  pairs
  (par (b) (((x (list b))) (list (pair b b))))
  (match x
    ((nil (_ nil (pair b b)))
     ((cons y z)
      (match z
        ((nil (_ nil (pair b b)))
         ((cons y2 xs) (cons (pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  map
  (par (a b) (((f (=> a b)) (x (list a))) (list b)))
  (match x
    ((nil (_ nil b))
     ((cons y xs) (cons (@ f y) (map f xs))))))
(define-fun-rec
  length
  (par (a) (((x (list a))) Int))
  (match x
    ((nil 0)
     ((cons y l) (+ 1 (length l))))))
(define-funs-rec
  ((evens
    (par (a) (((x (list a))) (list a))))
   (odds
    (par (a) (((x (list a))) (list a)))))
  ((match x
     ((nil (_ nil a))
      ((cons y xs) (cons y (odds xs)))))
   (match x
     ((nil (_ nil a))
      ((cons y xs) (evens xs))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (let ((eta (length xs)))
        (let ((md (mod eta 2)))
          (=>
            (=
              (ite
                (and
                  (= (ite (= eta 0) 0 (ite (<= eta 0) (- 0 1) 1))
                    (ite (<= 2 0) (- 0 (- 0 1)) (- 0 1)))
                  (distinct md 0))
                (- md 2) md)
              0)
            (=
              (map (lambda ((x (pair a a))) (match x (((pair2 y z) y))))
                (pairs xs))
              (evens xs))))))))
