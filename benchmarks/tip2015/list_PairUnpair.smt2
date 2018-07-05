(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (unpair
       ((x (list (pair a a)))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xys)
           (match y (case (pair2 z y2) (cons z (cons y2 (unpair xys))))))))))
(define-fun-rec
  (par (b)
    (pairs
       ((x (list b))) (list (pair b b))
       (match x
         (case nil (_ nil (pair b b)))
         (case (cons y z)
           (match z
             (case nil (_ nil (pair b b)))
             (case (cons y2 xs) (cons (pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y l) (+ 1 (length l)))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (let
        ((eta (length xs))
         (md (mod eta 2)))
        (=>
          (=
            (ite
              (and
                (= (ite (= eta 0) 0 (ite (<= eta 0) (- 0 1) 1))
                  (ite (<= 2 0) (- 0 (- 0 1)) (- 0 1)))
                (distinct md 0))
              (- md 2) md)
            0)
          (= (unpair (pairs xs)) xs))))))
