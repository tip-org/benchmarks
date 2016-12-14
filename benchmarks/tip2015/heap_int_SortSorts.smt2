; Skew heaps
;
; The sort function returns a sorted list.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Heap (Node (proj1-Node Heap) (proj2-Node Int) (proj3-Node Heap))
     (Nil))))
(define-fun-rec
  (par (a)
    (ordered-ordered1
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z)
           (match z
             (case nil true)
             (case (cons y2 xs) (and (<= y y2) (ordered-ordered1 z)))))))))
(define-fun-rec
  merge
    ((x Heap) (y Heap)) Heap
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (<= x2 x5) (Node (merge x3 y) x2 z) (Node (merge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  toList2
    ((x Int) (y Heap)) (list Int)
    (ite
      (= x 0) (as nil (list Int))
      (match y
        (case (Node p z q) (cons z (toList2 (- x 1) (merge p q))))
        (case Nil (as nil (list Int))))))
(define-fun
  insert2 ((x Int) (y Heap)) Heap (merge (Node Nil x Nil) y))
(define-fun-rec
  toHeap
    ((x (list Int))) Heap
    (match x
      (case nil Nil)
      (case (cons y xs) (insert2 y (toHeap xs)))))
(define-fun-rec
  heapSize
    ((x Heap)) Int
    (match x
      (case (Node l y r) (+ (+ 1 (heapSize l)) (heapSize r)))
      (case Nil 0)))
(define-fun toList ((x Heap)) (list Int) (toList2 (heapSize x) x))
(define-fun hsort ((x (list Int))) (list Int) (toList (toHeap x)))
(assert-not (forall ((x (list Int))) (ordered-ordered1 (hsort x))))
(check-sat)
