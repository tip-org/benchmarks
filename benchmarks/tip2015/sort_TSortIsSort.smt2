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
  insert :source Sort.insert
    ((x Int) (y (list Int))) (list Int)
    (match y
      (case nil (cons x (_ nil Int)))
      (case (cons z xs)
        (ite (<= x z) (cons x y) (cons z (insert x xs))))))
(define-fun-rec
  isort :source Sort.sort
    ((x (list Int))) (list Int)
    (match x
      (case nil (_ nil Int))
      (case (cons y xs) (insert y (isort xs)))))
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
  :source Sort.prop_TSortIsSort
  (forall ((xs (list Int))) (= (tsort xs) (isort xs))))
