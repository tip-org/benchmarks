(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(declare-datatypes ()
  ((Expr (Var (Var_0 Nat))
     (Plus (Plus_0 Expr) (Plus_1 Expr)) (Mul (Mul_0 Expr) (Mul_1 Expr))
     (Const (Const_0 Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(define-fun-rec
  mult
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S n) (plus y (mult n y)))))
(define-fun-rec
  (par (a)
    (index
       ((x (list a)) (y Nat)) (Maybe a)
       (match x
         (case nil (as Nothing (Maybe a)))
         (case (cons z xs)
           (match y
             (case Z (Just z))
             (case (S n) (index xs n))))))))
(define-fun-rec
  eval
    ((x (list Nat)) (y Expr)) Nat
    (match y
      (case (Var z)
        (match (index x z)
          (case Nothing (S Z))
          (case (Just y2) y2)))
      (case (Plus p1 p2) (plus (eval x p1) (eval x p2)))
      (case (Mul p12 p22) (mult (eval x p12) (eval x p22)))
      (case (Const c) (S c))))
(assert-not
  (forall ((e Expr))
    (or
      (distinct (eval (cons Z (as nil (list Nat))) e)
        (mult (mult (S Z) (S Z)) (S Z)))
      (or
        (distinct (eval (cons (S Z) (as nil (list Nat))) e)
          (mult (mult (S (S Z)) (S (S Z))) (S (S Z))))
        (or
          (distinct (eval (cons (S (S Z)) (as nil (list Nat))) e)
            (mult (mult (S (S (S Z))) (S (S (S Z)))) (S (S (S Z)))))
          (distinct (eval (cons (S (S (S Z))) (as nil (list Nat))) e)
            (mult (mult (S (S (S (S Z)))) (S (S (S (S Z)))))
              (S (S (S (S Z)))))))))))
(check-sat)
