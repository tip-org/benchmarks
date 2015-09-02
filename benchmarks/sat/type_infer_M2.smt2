(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Ty (Arr (Arr_0 Ty) (Arr_1 Ty)) (A) (B) (C))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(declare-datatypes ()
  ((Expr (App (App_0 Expr) (App_1 Expr) (App_2 Ty))
     (Lam (Lam_0 Expr)) (Var (Var_0 Nat)))))
(define-fun y () Expr (Var (S Z)))
(define-fun x () Expr (Var Z))
(define-fun-rec
  (par (a)
    (index
       ((z (list a)) (x2 Nat)) (Maybe a)
       (match z
         (case nil (as Nothing (Maybe a)))
         (case (cons x3 xs)
           (match x2
             (case Z (Just x3))
             (case (S n) (index xs n))))))))
(define-fun g () Expr (Var (S (S Z))))
(define-fun-rec
  eqType
    ((z Ty) (x2 Ty)) Bool
    (match z
      (case (Arr a x3)
        (match x2
          (case default false)
          (case (Arr b y2) (and (eqType a b) (eqType x3 y2)))))
      (case A
        (match x2
          (case default false)
          (case A true)))
      (case B
        (match x2
          (case default false)
          (case B true)))
      (case C
        (match x2
          (case default false)
          (case C true)))))
(define-fun-rec
  tc
    ((z (list Ty)) (x2 Expr) (x3 Ty)) Bool
    (match x2
      (case (App f x4 tx) (and (tc z f (Arr tx x3)) (tc z x4 tx)))
      (case (Lam e)
        (match x3
          (case default false)
          (case (Arr tx2 t) (tc (cons tx2 z) e t))))
      (case (Var x5)
        (match (index z x5)
          (case Nothing false)
          (case (Just tx3) (eqType tx3 x3))))))
(assert-not
  (forall ((t Ty) (t1 Ty) (t2 Ty))
    (or
      (not
        (tc (as nil (list Ty))
          (Lam (Lam (Lam (App (App g y t1) x t2)))) t))
      (= t1 t2))))
(check-sat)
