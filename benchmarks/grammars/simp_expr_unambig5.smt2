; Show function for a simple expression language
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (C) (D) (X) (Y) (Pl))))
(declare-datatypes () ((T (TX) (TY))))
(declare-datatypes ()
  ((E (Plus (Plus_0 T) (Plus_1 E)) (Term (Term_0 T)))))
(define-fun
  linTerm
    ((x T)) (list Tok)
    (match x
      (case TX (cons X (as nil (list Tok))))
      (case TY (cons Y (as nil (list Tok))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  lin
    ((x E)) (list Tok)
    (match x
      (case (Plus a b)
        (append (linTerm a)
          (append (cons Pl (as nil (list Tok))) (lin b))))
      (case (Term t) (linTerm t))))
(assert-not
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
(check-sat)
