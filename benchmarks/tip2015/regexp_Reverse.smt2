; Regular expressions using Brzozowski derivatives (see the step function)
; The plus and seq functions are smart constructors.
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype A ((X) (Y)))
(declare-datatype
  R
  ((Nil) (Eps) (Atom (proj1-Atom A))
   (Plus (proj1-Plus R) (proj2-Plus R))
   (Seq (proj1-Seq R) (proj2-Seq R)) (Star (proj1-Star R))))
(define-fun
  seq
  ((x R) (y R)) R
  (match x
    ((Nil Nil)
     (_
      (match y
        ((Nil Nil)
         (_
          (match x
            ((Eps y)
             (_
              (match y
                ((Eps x)
                 (_ (Seq x y))))))))))))))
(define-fun-rec
  rev
  ((x R)) R
  (match x
    (((Plus a b) (Plus (rev a) (rev b)))
     ((Seq c b2) (Seq (rev b2) (rev c)))
     ((Star a2) (Star (rev a2)))
     (_ x))))
(define-fun
  plus
  ((x R) (y R)) R
  (match x
    ((Nil y)
     (_
      (match y
        ((Nil x)
         (_ (Plus x y))))))))
(define-fun
  eqA
  ((x A) (y A)) Bool
  (match x
    ((X
      (match y
        ((X true)
         (Y false))))
     (Y
      (match y
        ((X false)
         (Y true)))))))
(define-fun-rec
  eps
  ((x R)) Bool
  (match x
    ((Eps true)
     ((Plus p q) (or (eps p) (eps q)))
     ((Seq r q2) (and (eps r) (eps q2)))
     ((Star y) true)
     (_ false))))
(define-fun
  epsR
  ((x R)) R (ite (eps x) Eps Nil))
(define-fun-rec
  step
  ((x R) (y A)) R
  (match x
    (((Atom a) (ite (eqA a y) Eps Nil))
     ((Plus p q) (plus (step p y) (step q y)))
     ((Seq r q2) (plus (seq (step r y) q2) (seq (epsR r) (step q2 y))))
     ((Star p2) (seq (step p2 y) x))
     (_ Nil))))
(define-fun-rec
  recognise
  ((x R) (y (list A))) Bool
  (match y
    ((nil (eps x))
     ((cons z xs) (recognise (step x z) xs)))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  reverse
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (++ (reverse xs) (cons y (_ nil a)))))))
(prove
  (forall ((r R) (s (list A)))
    (= (recognise (rev r) s) (recognise r (reverse s)))))
