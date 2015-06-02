; Skew heaps
;
; The sort function permutes the input list, version 2.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Heap (Node (Node_0 Heap) (Node_1 Nat) (Node_2 Heap)) (Nil))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S n) (S (plus n y))))))
(define-funs-rec
  ((par (a) (null ((x (list a))) Bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((le ((x Nat) (y Nat)) Bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (le z x2)))))))
(define-funs-rec
  ((merge ((x Heap) (y Heap)) Heap))
  ((match x
     (case (Node z x2 x3)
       (match y
         (case (Node x4 x5 x6)
           (ite
             (le x2 x5) (Node (merge x3 y) x2 z) (Node (merge x x6) x5 x4)))
         (case Nil x)))
     (case Nil y))))
(define-funs-rec
  ((toList ((x Nat) (y Heap)) (list Nat)))
  ((match x
     (case Z (as nil (list Nat)))
     (case (S z)
       (match y
         (case (Node x2 x3 x4) (cons x3 (toList z (merge x2 x4))))
         (case Nil (as nil (list Nat))))))))
(define-funs-rec
  ((insert2 ((x Nat) (y Heap)) Heap)) ((merge (Node Nil x Nil) y)))
(define-funs-rec
  ((toHeap ((x (list Nat))) Heap))
  ((match x
     (case nil Nil)
     (case (cons y xs) (insert2 y (toHeap xs))))))
(define-funs-rec
  ((heapSize ((x Heap)) Nat))
  ((match x
     (case (Node l y r) (S (plus (heapSize l) (heapSize r))))
     (case Nil Z))))
(define-funs-rec
  ((toList2 ((x Heap)) (list Nat))) ((toList (heapSize x) x)))
(define-funs-rec
  ((hsort ((x (list Nat))) (list Nat))) ((toList2 (toHeap x))))
(define-funs-rec
  ((equal ((x Nat) (y Nat)) Bool))
  ((match x
     (case Z
       (match y
         (case Z true)
         (case (S z) false)))
     (case (S x2)
       (match y
         (case Z false)
         (case (S y2) (equal x2 y2)))))))
(define-funs-rec
  ((elem ((x Nat) (y (list Nat))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or (equal x z) (elem x ys))))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((delete ((x Nat) (y (list Nat))) (list Nat)))
  ((match y
     (case nil (as nil (list Nat)))
     (case (cons z ys) (ite (equal x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((isPermutation ((x (list Nat)) (y (list Nat))) Bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and (elem z y) (isPermutation xs (delete z y)))))))
(assert-not (forall ((x (list Nat))) (isPermutation (hsort x) x)))
(check-sat)
