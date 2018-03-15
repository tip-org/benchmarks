; Bubble sort
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  leq :definition :source |<=|
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(define-fun-rec
  ordered :source SortUtils.ordered
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (leq y y2) (ordered z)))))))
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
              (leq y y2)
              (match (bubble z)
                (case (pair2 b12 ys12) (pair2 b12 (cons y ys12))))
              (match (bubble (cons y xs))
                (case (pair2 b1 ys1) (pair2 true (cons y2 ys1))))))))))
(define-fun-rec
  bubsort :source Sort.bubsort
    ((x (list Nat))) (list Nat)
    (match (bubble x) (case (pair2 c ys1) (ite c (bubsort ys1) x))))
(prove
  :source Sort.prop_BubSortSorts
  (forall ((xs (list Nat))) (ordered (bubsort xs))))
