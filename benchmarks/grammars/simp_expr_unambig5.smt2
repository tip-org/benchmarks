; Show function for a simple expression language
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Tok :source SimpleExpr5.Tok (C :source SimpleExpr5.C)
     (D :source SimpleExpr5.D) (X :source SimpleExpr5.X)
     (Y :source SimpleExpr5.Y) (Pl :source SimpleExpr5.Pl))))
(declare-datatypes ()
  ((T :source SimpleExpr5.T (TX :source SimpleExpr5.TX)
     (TY :source SimpleExpr5.TY))))
(declare-datatypes ()
  ((E :source SimpleExpr5.E
     (Plus :source SimpleExpr5.Plus (proj1-Plus T) (proj2-Plus E))
     (Term :source SimpleExpr5.Term (proj1-Term T)))))
(define-fun
  linTerm :source SimpleExpr5.linTerm
    ((x T)) (list Tok)
    (match x
      (case TX (cons X (_ nil Tok)))
      (case TY (cons Y (_ nil Tok)))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  lin :source SimpleExpr5.lin
    ((x E)) (list Tok)
    (match x
      (case (Plus a b)
        (++ (linTerm a) (++ (cons Pl (_ nil Tok)) (lin b))))
      (case (Term t) (linTerm t))))
(prove
  :source SimpleExpr5.prop_unambig5
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
