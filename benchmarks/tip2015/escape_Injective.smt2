; Escaping and unescaping
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Token (A) (B) (C) (D) (ESC) (P) (Q) (R))))
(define-fun
  isSpecial
    ((x Token)) Bool
    (match x
      (case default false)
      (case ESC true)
      (case P true)
      (case Q true)
      (case R true)))
(define-fun
  code
    ((x Token)) Token
    (match x
      (case default x)
      (case ESC ESC)
      (case P A)
      (case Q B)
      (case R C)))
(define-fun-rec
  escape
    ((x (list Token))) (list Token)
    (match x
      (case nil (_ nil Token))
      (case (cons y xs)
        (ite
          (isSpecial y) (cons ESC (cons (code y) (escape xs)))
          (cons y (escape xs))))))
(prove
  (forall ((xs (list Token)) (ys (list Token)))
    (=> (= (escape xs) (escape ys)) (= xs ys))))
