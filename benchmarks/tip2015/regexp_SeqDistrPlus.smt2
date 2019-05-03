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
    ((_
      (match y
        ((_
          (match x
            ((_
              (match y
                ((_ (Seq x y))
                 (Eps x))))
             (Eps y))))
         (Nil Nil))))
     (Nil Nil))))
(define-fun
  plus
  ((x R) (y R)) R
  (match x
    ((_
      (match y
        ((_ (Plus x y))
         (Nil x))))
     (Nil y))))
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
    ((_ false)
     (Eps true)
     ((Plus p q) (or (eps p) (eps q)))
     ((Seq r q2) (and (eps r) (eps q2)))
     ((Star y) true))))
(define-fun
  epsR
  ((x R)) R (ite (eps x) Eps Nil))
(define-fun-rec
  step
  ((x R) (y A)) R
  (match x
    ((_ Nil)
     ((Atom a) (ite (eqA a y) Eps Nil))
     ((Plus p q) (plus (step p y) (step q y)))
     ((Seq r q2) (plus (seq (step r y) q2) (seq (epsR r) (step q2 y))))
     ((Star p2) (seq (step p2 y) x)))))
(define-fun-rec
  recognise
  ((x R) (y (list A))) Bool
  (match y
    ((nil (eps x))
     ((cons z xs) (recognise (step x z) xs)))))
(prove
  (forall ((p R) (q R) (r R) (s (list A)))
    (= (recognise (Seq p (Plus q r)) s)
      (recognise (Plus (Seq p q) (Seq p r)) s))))
