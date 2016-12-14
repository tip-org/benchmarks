; Show function for a simple expression language
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (C) (D) (X) (Y) (Pl))))
(declare-datatypes () ((T (TX) (TY))))
(declare-datatypes ()
  ((E (Plus (proj1-Plus T) (proj2-Plus E)) (Term (proj1-Term T)))))
(define-fun
  linTerm
    ((x T)) (list Tok)
    (match x
      (case TX (cons X (as nil (list Tok))))
      (case TY (cons Y (as nil (list Tok))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  lin
    ((x E)) (list Tok)
    (match x
      (case (Plus a b)
        (++ (linTerm a) (++ (cons Pl (as nil (list Tok))) (lin b))))
      (case (Term t) (linTerm t))))
(assert-not
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
(check-sat)
