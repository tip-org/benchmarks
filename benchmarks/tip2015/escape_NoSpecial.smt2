; Escaping and unescaping
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Token ((A) (B) (C) (D) (ESC) (P) (Q) (R)))
(define-fun
  isSpecial
  ((x Token)) Bool
  (match x
    ((ESC true)
     (P true)
     (Q true)
     (R true)
     (_ false))))
(define-fun
  ok
  ((x Token)) Bool
  (or (not (isSpecial x))
    (match x
      ((ESC true)
       (_ false)))))
(define-fun-rec
  formula
  ((x (list Token))) Bool
  (match x
    ((nil true)
     ((cons y xs) (and (ok y) (formula xs))))))
(define-fun
  code
  ((x Token)) Token
  (match x
    ((ESC ESC)
     (P A)
     (Q B)
     (R C)
     (_ x))))
(define-fun-rec
  escape
  ((x (list Token))) (list Token)
  (match x
    ((nil (_ nil Token))
     ((cons y xs)
      (ite
        (isSpecial y) (cons ESC (cons (code y) (escape xs)))
        (cons y (escape xs)))))))
(prove (forall ((xs (list Token))) (formula (escape xs))))
