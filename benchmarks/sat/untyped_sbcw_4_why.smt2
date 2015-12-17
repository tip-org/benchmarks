(declare-datatypes ()
  ((Term (Ap (Ap_0 Term) (Ap_1 Term)) (Var) (I) (S) (B) (C) (W))))
(declare-datatypes () ((Nat (Zero) (Suc (Suc_0 Nat)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(define-fun-rec
  varFree
    ((x Term)) Bool
    (match x
      (case default true)
      (case (Ap a b) (and (varFree a) (varFree b)))
      (case Var false)))
(define-fun
  par2
    ((x Term) (y Term) (z (Maybe Term)) (x2 (Maybe Term))) (Maybe Term)
    (match z
      (case Nothing
        (match x2
          (case Nothing (as Nothing (Maybe Term)))
          (case (Just u_red) (Just (Ap x u_red)))))
      (case (Just t_red)
        (match x2
          (case Nothing (Just (Ap t_red y)))
          (case (Just u_red2) (Just (Ap t_red u_red2)))))))
(define-fun-rec
  step
    ((x Term)) (Maybe Term)
    (match x
      (case default (as Nothing (Maybe Term)))
      (case (Ap y z)
        (let ((x2 (par2 y z (step y) (step z))))
          (match y
            (case default x2)
            (case (Ap x3 g)
              (match x3
                (case default x2)
                (case (Ap x4 f)
                  (match x4
                    (case default x2)
                    (case S (Just (Ap (Ap f z) (Ap g z))))
                    (case B (Just (Ap f (Ap g z))))
                    (case C (Just (Ap (Ap f z) g)))))
                (case W (Just (Ap (Ap g z) z)))))
            (case I (Just z)))))))
(define-fun four () Nat (Suc (Suc (Suc (Suc Zero)))))
(define-fun-rec
  astep
    ((x Nat) (y Term)) (Maybe Term)
    (match x
      (case Zero (Just y))
      (case (Suc n)
        (match (step y)
          (case Nothing (as Nothing (Maybe Term)))
          (case (Just u) (astep n u))))))
(assert-not
  (forall ((y Term))
    (or (not (varFree y))
      (distinct (astep four (Ap y Var)) (Just (Ap Var (Ap y Var)))))))
(check-sat)
