; Escaping and unescaping
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Token :source Escape.Token (A :source Escape.A)
     (B :source Escape.B) (C :source Escape.C) (D :source Escape.D)
     (ESC :source Escape.ESC) (P :source Escape.P) (Q :source Escape.Q)
     (R :source Escape.R))))
(define-fun
  isSpecial :source Escape.isSpecial
    ((x Token)) Bool
    (match x
      (case default false)
      (case ESC true)
      (case P true)
      (case Q true)
      (case R true)))
(define-fun
  ok :source Escape.ok
    ((x Token)) Bool
    (or (not (isSpecial x))
      (match x
        (case default false)
        (case ESC true))))
(define-fun-rec
  formula :let
    ((x (list Token))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (ok y) (formula xs)))))
(define-fun
  code :source Escape.code
    ((x Token)) Token
    (match x
      (case default x)
      (case ESC ESC)
      (case P A)
      (case Q B)
      (case R C)))
(define-fun-rec
  escape :source Escape.escape
    ((x (list Token))) (list Token)
    (match x
      (case nil (_ nil Token))
      (case (cons y xs)
        (ite
          (isSpecial y) (cons ESC (cons (code y) (escape xs)))
          (cons y (escape xs))))))
(prove
  :source Escape.prop_NoSpecial
  (forall ((xs (list Token))) (formula (escape xs))))
