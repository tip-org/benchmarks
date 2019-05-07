(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  unpair
  (par (a) (((x (list (pair a a)))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xys)
      (match y (((pair2 z y2) (cons z (cons y2 (unpair xys))))))))))
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
  length
  (par (a) (((x (list a))) Int))
  (match x
    ((nil 0)
     ((cons y l) (+ 1 (length l))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (=> (= (mod (length xs) 2) 0) (= (unpair (pairs xs)) xs)))))
