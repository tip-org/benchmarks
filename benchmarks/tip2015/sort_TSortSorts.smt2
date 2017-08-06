; Tree sort
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Tree :source Sort.Tree
     (TNode :source Sort.TNode (proj1-TNode Tree)
       (proj2-TNode Int) (proj3-TNode Tree))
     (TNil :source Sort.TNil))))
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
  flatten :source Sort.flatten
    ((x Tree) (y (list Int))) (list Int)
    (match x
      (case (TNode p z q) (flatten p (cons z (flatten q y))))
      (case TNil y)))
(define-fun-rec
  add :source Sort.add
    ((x Int) (y Tree)) Tree
    (match y
      (case (TNode p z q)
        (ite (<= x z) (TNode (add x p) z q) (TNode p z (add x q))))
      (case TNil (TNode TNil x TNil))))
(define-fun-rec
  toTree :source Sort.toTree
    ((x (list Int))) Tree
    (match x
      (case nil TNil)
      (case (cons y xs) (add y (toTree xs)))))
(define-fun
  tsort :source Sort.tsort
    ((x (list Int))) (list Int) (flatten (toTree x) (_ nil Int)))
(prove
  :source Sort.prop_TSortSorts
  (forall ((xs (list Int))) (ordered (tsort xs))))
