(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Ty (Arr (Arr_0 Ty) (Arr_1 Ty))
     (A) (B) (C) (Prod (Prod_0 Ty) (Prod_1 Ty)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(declare-datatypes ()
  ((Expr (App (App_0 Expr) (App_1 Expr) (App_2 Ty))
     (Lam (Lam_0 Expr)) (Var (Var_0 Nat))
     (Pair (first Expr) (second Expr)) (Fst (Fst_0 Expr) (Fst_1 Ty))
     (Snd (Snd_0 Ty) (Snd_1 Expr)))))
(define-fun-rec
  pnf
    ((x Expr)) Bool
    (match x
      (case (App y z x2)
        (match y
          (case default (and (pnf y) (pnf z)))
          (case (Lam x3) false)))
      (case (Lam e) (pnf e))
      (case (Var x4) true)
      (case (Pair u v) (and (pnf u) (pnf v)))
      (case (Fst x5 x6)
        (match x5
          (case default (pnf x5))
          (case (Pair x7 x8) false)))
      (case (Snd x9 x10)
        (match x10
          (case default (pnf x10))
          (case (Pair x11 x12) false)))))
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
          (case C true)))
      (case (Prod c x2)
        (match y
          (case default false)
          (case (Prod b2 y3) (and (eqType c b2) (eqType x2 y3)))))))
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
          (case (Just tx3) (eqType tx3 z))))
      (case (Pair u v)
        (match z
          (case default false)
          (case (Prod tu tv) (and (tc x u tu) (tc x v tv)))))
      (case (Fst e2 tr) (tc x e2 (Prod z tr)))
      (case (Snd tl e3) (tc x e3 (Prod tl z)))))
(assert-not
  (forall ((e Expr))
    (or (not (pnf e))
      (not
        (tc (as nil (list Ty))
          e (Arr (Arr A (Prod B C)) (Prod (Arr A C) (Arr A B))))))))
(check-sat)
