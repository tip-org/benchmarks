(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (b)
    (pairs :source List.pairs
       ((x (list b))) (list (pair b b))
       (match x
         (case nil (_ nil (pair b b)))
         (case (cons y z)
           (match z
             (case nil (_ nil (pair b b)))
             (case (cons y2 xs) (cons (pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  (par (a b)
    (map :let :source Prelude.map
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (_ nil b))
         (case (cons y xs) (cons (@ f y) (map f xs)))))))
(define-fun-rec
  (par (a)
    (length :source Prelude.length
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y l) (+ 1 (length l)))))))
(define-funs-rec
  ((par (a) (evens :source List.evens ((x (list a))) (list a)))
   (par (a) (odds :source List.odds ((x (list a))) (list a))))
  ((match x
     (case nil (_ nil a))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (_ nil a))
     (case (cons y xs) (evens xs)))))
(prove
  :source List.prop_PairEvens
  (par (a)
    (forall ((xs (list a)))
      (=>
        (let ((eta (length xs)))
          (=
            (let ((md (mod eta 2)))
              (ite
                (and
                  (= (ite (= eta 0) 0 (ite (<= eta 0) (- 0 1) 1))
                    (ite (<= 2 0) (- 0 (- 0 1)) (- 0 1)))
                  (distinct md 0))
                (- md 2) md))
            0))
        (=
          (map (lambda ((x (pair a a))) (match x (case (pair2 y z) y)))
            (pairs xs))
          (evens xs))))))
