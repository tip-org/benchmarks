(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Tok ((C) (D) (X) (Y) (Plus) (Mul)))
(declare-datatype
  E
  ((|:+:| (|proj1-:+:| E) (|proj2-:+:| E))
   (|:*:| (|proj1-:*:| E) (|proj2-:*:| E)) (EX) (EY)))
(define-fun-rec
  assoc
  ((x E)) E
  (match x
    (((|:+:| y c)
      (match y
        (((|:+:| a b) (assoc (|:+:| a (|:+:| b c))))
         (_ (|:+:| (assoc y) (assoc c))))))
     ((|:*:| a2 b2) (|:*:| (assoc a2) (assoc b2)))
     (_ x))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-funs-rec
  ((linTerm
    ((x E)) (list Tok))
   (lin
    ((x E)) (list Tok)))
  ((match x
     (((|:*:| a b)
       (++ (cons C (_ nil Tok))
         (++ (lin (|:+:| a b)) (cons D (_ nil Tok)))))
      (_ (lin x))))
   (match x
     (((|:+:| a b)
       (++ (linTerm a) (++ (cons Plus (_ nil Tok)) (linTerm b))))
      ((|:*:| a3 b2) (++ (lin a3) (++ (cons Mul (_ nil Tok)) (lin b2))))
      (EX (cons X (_ nil Tok)))
      (EY (cons Y (_ nil Tok)))))))
(prove
  (forall ((u E) (v E))
    (=> (= (lin u) (lin v)) (= (assoc u) (assoc v)))))
