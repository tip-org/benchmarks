; Selection sort, using a total minimum function
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  ssort-minimum1 :let
    ((x Int) (y (list Int))) Int
    (match y
      (case nil x)
      (case (cons y1 ys1)
        (ite (<= y1 x) (ssort-minimum1 y1 ys1) (ssort-minimum1 x ys1)))))
(define-fun-rec
  ordered :source SortUtils.ordered
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (<= y y2) (ordered z)))))))
(define-fun-rec
  (par (a)
    (deleteBy :source Data.List.deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (_ nil a))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  ssort :source Sort.ssort
    ((x (list Int))) (list Int)
    (match x
      (case nil (_ nil Int))
      (case (cons y ys)
        (let ((m (ssort-minimum1 y ys)))
          (cons m
            (ssort
              (deleteBy (lambda ((z Int)) (lambda ((x2 Int)) (= z x2)))
                m x)))))))
(prove
  :source Sort.prop_SSortSorts
  (forall ((xs (list Int))) (ordered (ssort xs))))
