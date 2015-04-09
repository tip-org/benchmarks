; Simple expression unambiguity
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (C) (D) (X) (Y) (Pl))))
(declare-datatypes () ((T (TX) (TY))))
(declare-datatypes
  () ((E (Plus (Plus_ T) (Plus_2 E)) (Term (Term_ T)))))
(define-funs-rec
  ((linTerm ((x T)) (list Tok)))
  ((match x
     (case TX (cons X (as nil (list Tok))))
     (case TY (cons Y (as nil (list Tok)))))))
(define-funs-rec
  ((par (a3) (append ((x3 (list a3)) (x4 (list a3))) (list a3))))
  ((match x3
     (case nil x4)
     (case (cons x5 xs) (cons x5 (as (append xs x4) (list a3)))))))
(define-funs-rec
  ((lin ((x2 E)) (list Tok)))
  ((match x2
     (case
       (Plus a2 b)
       (append
         (append (linTerm a2) (cons Pl (as nil (list Tok)))) (lin b)))
     (case (Term t) (linTerm t)))))
(assert-not
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
(check-sat)
