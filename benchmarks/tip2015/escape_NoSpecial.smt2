; Escaping
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Token (A) (B) (C) (D) (ESC) (P) (Q) (R))))
(define-funs-rec
  ((or2 ((x10 bool) (x11 bool)) bool (ite x10 x10 x11))))
(define-funs-rec
  ((isSpecial
      ((x2 Token)) bool
      (match x2
        (case default false)
        (case ESC true)
        (case P true)
        (case Q true)
        (case R true)))))
(define-funs-rec
  ((isEsc
      ((x3 Token)) bool
      (match x3
        (case default false)
        (case ESC true)))))
(define-funs-rec
  ((ok ((x Token)) bool (or2 (not (isSpecial x)) (isEsc x)))))
(define-funs-rec
  ((code
      ((x6 Token)) Token
      (match x6
        (case default x6)
        (case ESC x6)
        (case P A)
        (case Q B)
        (case R C)))))
(define-funs-rec
  ((escape
      ((x4 (list Token))) (list Token)
      (match x4
        (case nil x4)
        (case
          (cons x5 xs)
          (ite
            (isSpecial x5) (cons ESC (cons (code x5) (escape xs)))
            (cons x5 (escape xs))))))))
(define-funs-rec
  ((and2 ((x12 bool) (x13 bool)) bool (ite x12 x13 x12))))
(define-funs-rec
  ((par
     (a2)
     (all
        ((x7 (=> a2 bool)) (x8 (list a2))) bool
        (match x8
          (case nil true)
          (case (cons x9 xs2) (and2 (@ x7 x9) (as (all x7 xs2) bool))))))))
(assert
  (not
    (forall
      ((xs3 (list Token)))
      (all (lambda ((x14 Token)) (ok x14)) (escape xs3)))))
(check-sat)
