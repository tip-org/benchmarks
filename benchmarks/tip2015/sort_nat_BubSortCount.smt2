; Bubble sort
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Nat
       (match y
         (case nil Z)
         (case (cons z ys)
           (ite (= x z) (plus (S Z) (count x ys)) (count x ys)))))))
(define-fun-rec
  bubble :source Sort.bubble
    ((x (list Nat))) (pair Bool (list Nat))
    (match x
      (case nil (pair2 false (_ nil Nat)))
      (case (cons y z)
        (match z
          (case nil (pair2 false (cons y (_ nil Nat))))
          (case (cons y2 xs)
            (ite
              (le y y2)
              (match (bubble z)
                (case (pair2 b22 ys22) (pair2 b22 (cons y ys22))))
              (match (bubble (cons y xs))
                (case (pair2 b2 ys2) (pair2 true (cons y2 ys2))))))))))
(define-fun-rec
  bubsort :source Sort.bubsort
    ((x (list Nat))) (list Nat)
    (match (bubble x) (case (pair2 b1 ys) (ite b1 (bubsort ys) x))))
(prove
  :source Sort.prop_BubSortCount
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (bubsort xs)) (count x xs))))
