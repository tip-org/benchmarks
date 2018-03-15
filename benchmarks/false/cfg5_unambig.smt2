(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Tok :source CFG5.Tok (C :source CFG5.C)
     (D :source CFG5.D) (X :source CFG5.X) (Y :source CFG5.Y)
     (Plus :source CFG5.Plus) (Mul :source CFG5.Mul))))
(declare-datatypes ()
  ((E :source CFG5.E
     (|:+:| :source |CFG5.:+:| (|proj1-:+:| E) (|proj2-:+:| E))
     (|:*:| :source |CFG5.:*:| (|proj1-:*:| E) (|proj2-:*:| E))
     (EX :source CFG5.EX) (EY :source CFG5.EY))))
(define-fun-rec
  assoc :source CFG5.assoc
    ((x E)) E
    (match x
      (case default x)
      (case (|:+:| y c)
        (match y
          (case default (|:+:| (assoc y) (assoc c)))
          (case (|:+:| a b) (assoc (|:+:| a (|:+:| b c))))))
      (case (|:*:| a2 b2) (|:*:| (assoc a2) (assoc b2)))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((linTerm :source CFG5.linTerm ((x E)) (list Tok))
   (lin :source CFG5.lin ((x E)) (list Tok)))
  ((match x
     (case default (lin x))
     (case (|:*:| a b)
       (++ (cons C (_ nil Tok))
         (++ (lin (|:+:| a b)) (cons D (_ nil Tok))))))
   (match x
     (case (|:+:| a b)
       (++ (linTerm a) (++ (cons Plus (_ nil Tok)) (linTerm b))))
     (case (|:*:| a3 b2)
       (++ (lin a3) (++ (cons Mul (_ nil Tok)) (lin b2))))
     (case EX (cons X (_ nil Tok)))
     (case EY (cons Y (_ nil Tok))))))
(prove
  :source CFG5.prop_unambig
  (forall ((u E) (v E))
    (=> (= (lin u) (lin v)) (= (assoc u) (assoc v)))))
