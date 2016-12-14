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
  ok
    ((x Token)) Bool
    (or (not (isSpecial x))
      (match x
        (case default false)
        (case ESC true))))
(define-fun-rec
  formula
    ((x (list Token))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (ok y) (formula xs)))))
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
      (case nil (as nil (list Token)))
      (case (cons y xs)
        (ite
          (isSpecial y) (cons ESC (cons (code y) (escape xs)))
          (cons y (escape xs))))))
(assert-not (forall ((xs (list Token))) (formula (escape xs))))
(check-sat)
