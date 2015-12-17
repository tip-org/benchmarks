; From the Reach article
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(define-fun xnor ((x Bool) (y Bool)) Bool (ite x y (not y)))
(define-fun
  (par (t)
    (tl
       ((x (list t))) (list t)
       (match x
         (case nil (as nil (list t)))
         (case (cons y xs) xs)))))
(define-fun-rec
  orList
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (orList xs)))))
(define-fun-rec
  oneHot
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (ite y (not (orList xs)) (oneHot xs)))))
(define-fun
  (par (a)
    (null
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  (par (t)
    (map_tl
       ((x (list (list t)))) (list (list t))
       (match x
         (case nil (as nil (list (list t))))
         (case (cons y xs) (cons (tl y) (map_tl xs)))))))
(define-fun-rec
  (par (t)
    (len
       ((x (list t))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (len xs)))))))
(define-fun-rec
  (par (a)
    (index
       ((x (list a)) (y Nat)) (Maybe a)
       (match x
         (case nil (as Nothing (Maybe a)))
         (case (cons z xs)
           (match y
             (case Z (Just z))
             (case (S n) (index xs n))))))))
(define-fun
  (par (t)
    (hd
       ((x (list t))) (list t)
       (match x
         (case nil (as nil (list t)))
         (case (cons y xs) (cons y (as nil (list t))))))))
(define-fun-rec
  (par (t)
    (map_hd
       ((x (list (list t)))) (list (list t))
       (match x
         (case nil (as nil (list (list t))))
         (case (cons y xs) (cons (hd y) (map_hd xs)))))))
(define-fun-rec
  firstHot
    ((x (list Bool))) Nat
    (match x
      (case nil Z)
      (case (cons y xs) (ite y Z (S (firstHot xs))))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun-rec
  distAnd
    ((x Bool) (y (list Bool))) (list Bool)
    (match y
      (case nil (as nil (list Bool)))
      (case (cons z ys) (cons (and x z) (distAnd x ys)))))
(define-fun-rec
  zipDistAnd
    ((x (list Bool)) (y (list (list Bool)))) (list (list Bool))
    (match x
      (case nil (as nil (list (list Bool))))
      (case (cons z xs)
        (match y
          (case nil (as nil (list (list Bool))))
          (case (cons y2 ys) (cons (distAnd z y2) (zipDistAnd xs ys)))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (t)
    (flatten
       ((x (list (list t)))) (list t)
       (match x
         (case nil (as nil (list t)))
         (case (cons y xs) (append y (flatten xs)))))))
(define-fun-rec
  (par (t)
    (transpose
       ((x (list (list t)))) (list (list t))
       (match (flatten x)
         (case nil (as nil (list (list t))))
         (case (cons y z)
           (cons (flatten (map_hd x)) (transpose (map_tl x))))))))
(define-fun-rec
  orTree
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y z)
        (match z
          (case nil y)
          (case (cons y2 ys)
            (orTree (append ys (cons (or y y2) (as nil (list Bool))))))))))
(define-fun-rec
  map_orTree
    ((x (list (list Bool)))) (list Bool)
    (match x
      (case nil (as nil (list Bool)))
      (case (cons y xs) (cons (orTree y) (map_orTree xs)))))
(define-fun
  mux
    ((x (list Bool)) (y (list (list Bool)))) (list Bool)
    (map_orTree (transpose (zipDistAnd x y))))
(define-fun-rec
  (par (t)
    (allLen
       ((x Nat) (y (list (list t)))) Bool
       (match y
         (case nil true)
         (case (cons z xs) (and (equal (len z) x) (allLen x xs)))))))
(define-fun
  (par (t)
    (sameLen
       ((x (list (list t)))) Bool
       (match x
         (case nil true)
         (case (cons y xs) (allLen (len y) xs))))))
(define-fun-rec
  <=>
    ((x (list Bool)) (y (list Bool))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (match y
          (case nil false)
          (case (cons y2 ys) (and (xnor z y2) (<=> xs ys)))))))
(define-fun
  ok
    ((x (list Bool)) (y (list (list Bool))) (z Nat)) Bool
    (match (index y z)
      (case Nothing false)
      (case (Just c) (<=> (mux x y) c))))
(assert-not
  (forall ((sel (list Bool)) (xs (list (list Bool))))
    (=> (oneHot sel)
      (=> (equal (len sel) (len xs))
        (=> (sameLen xs) (ok sel xs (firstHot sel)))))))
(check-sat)
