(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (t)
    (unpair
       ((x (list (pair t t)))) (list t)
       (match x
         (case nil (as nil (list t)))
         (case (cons y xys)
           (match y (case (pair2 z y2) (cons z (cons y2 (unpair xys))))))))))
(define-fun-rec
  (par (t)
    (pairs
       ((x (list t))) (list (pair t t))
       (match x
         (case nil (as nil (list (pair t t))))
         (case (cons y z)
           (match z
             (case nil (as nil (list (pair t t))))
             (case (cons y2 xs) (cons (pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y l) (+ 1 (length l)))))))
(assert-not
  (par (t)
    (forall ((xs (list t)))
      (=>
        (=
          (let
            ((n1 (length xs))
             (md (mod n1 2)))
            (ite
              (and
                (= (ite (= n1 0) 0 (ite (<= n1 0) (- 0 1) 1))
                  (ite (<= 2 0) (- 0 (- 0 1)) (- 0 1)))
                (distinct md 0))
              (- md 2) md))
          0)
        (= (unpair (pairs xs)) xs)))))
(check-sat)
