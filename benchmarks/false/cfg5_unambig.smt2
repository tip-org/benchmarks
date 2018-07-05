(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (C) (D) (X) (Y) (Plus) (Mul))))
(declare-datatypes ()
  ((E (|:+:| (|proj1-:+:| E) (|proj2-:+:| E))
     (|:*:| (|proj1-:*:| E) (|proj2-:*:| E)) (EX) (EY))))
(define-fun-rec
  assoc
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
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((linTerm ((x E)) (list Tok))
   (lin ((x E)) (list Tok)))
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
  (forall ((u E) (v E))
    (=> (= (lin u) (lin v)) (= (assoc u) (assoc v)))))
