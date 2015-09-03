(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Ty (Arr (Arr_0 Ty) (Arr_1 Ty)) (A) (B) (C))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(declare-datatypes ()
  ((Expr (App (App_0 Expr) (App_1 Expr) (App_2 Ty))
     (Lam (Lam_0 Expr)) (Var (Var_0 Nat)))))
(define-fun-rec
  nf
    ((x Expr)) Bool
    (match x
      (case (App y z x2)
        (match y
          (case default (and (nf y) (nf z)))
          (case (Lam x3) false)))
      (case (Lam e) (nf e))
      (case (Var x4) true)))
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
  eqType
    ((x Ty) (y Ty)) Bool
    (match x
      (case (Arr a z)
        (match y
          (case default false)
          (case (Arr b y2) (and (eqType a b) (eqType z y2)))))
      (case A
        (match y
          (case default false)
          (case A true)))
      (case B
        (match y
          (case default false)
          (case B true)))
      (case C
        (match y
          (case default false)
          (case C true)))))
(define-fun-rec
  tc
    ((x (list Ty)) (y Expr) (z Ty)) Bool
    (match y
      (case (App f x2 tx) (and (tc x f (Arr tx z)) (tc x x2 tx)))
      (case (Lam e)
        (match z
          (case default false)
          (case (Arr tx2 t) (tc (cons tx2 x) e t))))
      (case (Var x3)
        (match (index x x3)
          (case Nothing false)
          (case (Just tx3) (eqType tx3 z))))))
(assert-not
  (forall ((e Expr))
    (or (not (nf e))
      (not
        (tc (as nil (list Ty))
          e (Arr (Arr A (Arr B C)) (Arr B (Arr A C))))))))
(check-sat)
