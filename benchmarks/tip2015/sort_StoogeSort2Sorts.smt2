; Stooge sort
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (take :source Prelude.take
       ((x Int) (y (list a))) (list a)
       (ite
         (<= x 0) (_ nil a)
         (match y
           (case nil (_ nil a))
           (case (cons z xs) (cons z (take (- x 1) xs))))))))
(define-fun
  sort2 :source Sort.sort2
    ((x Int) (y Int)) (list Int)
    (ite
      (<= x y) (cons x (cons y (_ nil Int)))
      (cons y (cons x (_ nil Int)))))
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
    (length :source Prelude.length
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y l) (+ 1 (length l)))))))
(define-fun-rec
  (par (a)
    (drop :source Prelude.drop
       ((x Int) (y (list a))) (list a)
       (ite
         (<= x 0) y
         (match y
           (case nil (_ nil a))
           (case (cons z xs1) (drop (- x 1) xs1)))))))
(define-fun
  (par (a)
    (splitAt :source Prelude.splitAt
       ((x Int) (y (list a))) (pair (list a) (list a))
       (pair2 (take x y) (drop x y)))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((stooge2sort2 :source Sort.stooge2sort2
      ((x (list Int))) (list Int))
   (stoogesort2 :source Sort.stoogesort2 ((x (list Int))) (list Int))
   (stooge2sort1 :source Sort.stooge2sort1
      ((x (list Int))) (list Int)))
  ((match (splitAt (div (+ (* 2 (length x)) 1) 3) x)
     (case (pair2 ys1 zs) (++ (stoogesort2 ys1) zs)))
   (match x
     (case nil (_ nil Int))
     (case (cons y z)
       (match z
         (case nil (cons y (_ nil Int)))
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (stooge2sort2 (stooge2sort1 (stooge2sort2 x)))))))))
   (match (splitAt (div (length x) 3) x)
     (case (pair2 ys1 zs) (++ ys1 (stoogesort2 zs))))))
(prove
  :source Sort.prop_StoogeSort2Sorts
  (forall ((xs (list Int))) (ordered (stoogesort2 xs))))
