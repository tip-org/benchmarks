; Show function for a simple expression language
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Tok ((C) (D) (X) (Y) (Pl)))
(declare-datatype T ((TX) (TY)))
(declare-datatype
  E ((Plus (proj1-Plus T) (proj2-Plus E)) (Term (proj1-Term T))))
(define-fun
  linTerm
  ((x T)) (list Tok)
  (match x
    ((TX (cons X (_ nil Tok)))
     (TY (cons Y (_ nil Tok))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  lin
  ((x E)) (list Tok)
  (match x
    (((Plus a b) (++ (linTerm a) (++ (cons Pl (_ nil Tok)) (lin b))))
     ((Term t) (linTerm t)))))
(prove (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
