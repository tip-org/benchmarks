; Stooge sort, using thirds on natural numbers
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  twoThirds :source Sort.twoThirds
    ((x Int)) Int
    (ite
      (= x 2) 1
      (ite (= x 1) 1 (ite (= x 0) 0 (+ 2 (twoThirds (- x 3)))))))
(define-fun-rec
  third :source Sort.third
    ((x Int)) Int
    (ite
      (= x 2) 0 (ite (= x 1) 0 (ite (= x 0) 0 (+ 1 (third (- x 3)))))))
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
    (count :source SortUtils.count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((nstooge2sort2 :source Sort.nstooge2sort2
      ((x (list Int))) (list Int))
   (nstoogesort2 :source Sort.nstoogesort2
      ((x (list Int))) (list Int))
   (nstooge2sort1 :source Sort.nstooge2sort1
      ((x (list Int))) (list Int)))
  ((match (splitAt (twoThirds (length x)) x)
     (case (pair2 ys2 zs1) (++ (nstoogesort2 ys2) zs1)))
   (match x
     (case nil (_ nil Int))
     (case (cons y z)
       (match z
         (case nil (cons y (_ nil Int)))
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (nstooge2sort2 (nstooge2sort1 (nstooge2sort2 x)))))))))
   (match (splitAt (third (length x)) x)
     (case (pair2 ys2 zs1) (++ ys2 (nstoogesort2 zs1))))))
(prove
  :source Sort.prop_NStoogeSort2Count
  (forall ((x Int) (xs (list Int)))
    (= (count x (nstoogesort2 xs)) (count x xs))))
