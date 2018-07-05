(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (proj1-Just a)))))
(declare-datatypes (a)
  ((Map (Rest (proj1-Rest a))
     (Slot (proj1-Slot a) (proj2-Slot (Map a))))))
(declare-datatypes ()
  ((Reach (Init (proj1-Init (Map Int)))
     (CheckIn (proj1-CheckIn Int)
       (proj2-CheckIn Int) (proj3-CheckIn Int) (proj4-CheckIn Reach))
     (EnterRoom (proj1-EnterRoom Int)
       (proj2-EnterRoom Int) (proj3-EnterRoom (pair Int Int))
       (proj4-EnterRoom Reach))
     (ExitRoom (proj1-ExitRoom Int)
       (proj2-ExitRoom Int) (proj3-ExitRoom Reach)))))
(declare-datatypes ()
  ((State
     (State2 (proj1-State (Map (Maybe Int)))
       (proj2-State (Map Int)) (proj3-State (Map Bool))
       (proj4-State (Map (Map (Map Bool)))) (proj5-State (Map Int))
       (proj6-State (Map (Map Bool))) (proj7-State (Map Bool))))))
(define-fun
  safe
    ((x State)) (Map Bool)
    (match x (case (State2 y z x2 x3 x4 x5 x6) x6)))
(define-fun
  roomk
    ((x State)) (Map Int)
    (match x (case (State2 y z x2 x3 x4 x5 x6) x4)))
(define-fun
  owns
    ((x State)) (Map (Maybe Int))
    (match x (case (State2 y z x2 x3 x4 x5 x6) y)))
(define-fun
  issued
    ((x State)) (Map Bool)
    (match x (case (State2 y z x2 x3 x4 x5 x6) x2)))
(define-fun
  isin
    ((x State)) (Map (Map Bool))
    (match x (case (State2 y z x2 x3 x4 x5 x6) x5)))
(define-fun-rec
  inj-upto1
    ((x Int) (y Int) (z (Map Int))) Bool
    (ite
      (= x 0) true
      (match z
        (case (Rest y2) (distinct y y2))
        (case (Slot y3 m1)
          (and (distinct y y3) (inj-upto1 (- x 1) y m1))))))
(define-fun-rec
  inj
    ((x Int) (y (Map Int))) Bool
    (ite
      (= x 0) true
      (match y
        (case (Rest z) false)
        (case (Slot x2 m) (and (inj (- x 1) m) (inj-upto1 x x2 m))))))
(define-fun empty2 () (Map (Map Bool)) (Rest (Rest false)))
(define-fun empty () (Map Bool) (Rest false))
(define-fun
  currk
    ((x State)) (Map Int)
    (match x (case (State2 y z x2 x3 x4 x5 x6) z)))
(define-fun
  cards
    ((x State)) (Map (Map (Map Bool)))
    (match x (case (State2 y z x2 x3 x4 x5 x6) x3)))
(define-fun-rec
  <=>
    ((x (Map Bool)) (y (Map Bool))) Bool
    (match x
      (case (Rest z)
        (match y
          (case (Rest y2) (= z y2))
          (case (Slot y3 q) (and (= z y3) (<=> x q)))))
      (case (Slot x2 p)
        (match y
          (case (Rest y4) (and (= x2 y4) (<=> p y)))
          (case (Slot y5 r) (and (= x2 y5) (<=> p r)))))))
(define-fun-rec
  (par (a)
    (!=
       ((x (Map a)) (y (pair Int a))) (Map a)
       (match x
         (case (Rest z)
           (match y
             (case (pair2 x2 y2)
               (ite (= x2 0) (Slot y2 x) (Slot z (!= x (pair2 (- x2 1) y2)))))))
         (case (Slot x3 m1)
           (match y
             (case (pair2 x4 y3)
               (ite
                 (= x4 0) (Slot y3 m1) (Slot x3 (!= m1 (pair2 (- x4 1) y3)))))))))))
(define-fun
  add ((x Int) (y (Map Bool))) (Map Bool) (!= y (pair2 x true)))
(define-fun-rec
  range
    ((x (Map Int))) (Map Bool)
    (match x
      (case (Rest y) (add y empty))
      (case (Slot z m) (add z (range m)))))
(define-fun
  rem ((x Int) (y (Map Bool))) (Map Bool) (!= y (pair2 x false)))
(define-fun-rec
  (par (a)
    (!2
       ((x (Map a)) (y Int)) a
       (match x
         (case (Rest z) z)
         (case (Slot x2 m) (ite (= y 0) x2 (!2 m (- y 1))))))))
(define-fun
  add2
    ((x (pair Int Int)) (y (Map (Map Bool)))) (Map (Map Bool))
    (match x (case (pair2 z y2) (!= y (pair2 z (add y2 (!2 y z)))))))
(define-fun-rec
  reach
    ((x Int) (y Reach)) (Maybe State)
    (match y
      (case (Init initk)
        (ite
          (inj x initk)
          (Just
            (State2 (Rest (_ Nothing Int))
              initk (range initk) (Rest empty2) initk (Rest empty) (Rest true)))
          (_ Nothing State)))
      (case (CheckIn g r k q)
        (match (reach x q)
          (case Nothing (_ Nothing State))
          (case (Just s)
            (ite
              (and (<= r x) (not (!2 (issued s) k)))
              (match s
                (case (State2 z x2 x3 x4 x5 x6 x7)
                  (Just
                    (State2 (!= z (pair2 r (Just g)))
                      (!= x2 (pair2 r k)) (add k x3)
                      (!= x4 (pair2 g (add2 (pair2 (!2 x2 r) k) (!2 x4 g)))) x5 x6
                      (!= x7 (pair2 r false))))))
              (_ Nothing State)))))
      (case (EnterRoom f p x8 q2)
        (match x8
          (case (pair2 i |k'|)
            (match (reach x q2)
              (case Nothing (_ Nothing State))
              (case (Just t)
                (let ((rk (!2 (roomk t) p)))
                  (ite
                    (and (<= p x)
                      (and (!2 (!2 (!2 (cards t) f) i) |k'|) (or (= rk i) (= rk |k'|))))
                    (match t
                      (case (State2 x9 x10 x11 x12 x13 x14 x15)
                        (Just
                          (State2 x9
                            x10 x11 x12 (!= x13 (pair2 p |k'|))
                            (!= x14 (pair2 p (add f (!2 x14 p))))
                            (!= x15
                              (pair2 p
                                (or (and (= (!2 x9 p) (Just f)) (<=> (!2 x14 p) empty))
                                  (!2 x15 p))))))))
                    (_ Nothing State))))))))
      (case (ExitRoom h r2 q3)
        (match (reach x q3)
          (case Nothing (_ Nothing State))
          (case (Just s2)
            (ite
              (and (<= r2 x) (!2 (!2 (isin s2) r2) h))
              (match s2
                (case (State2 x16 x17 x18 x19 x20 x21 x22)
                  (Just
                    (State2 x16
                      x17 x18 x19 x20 (!= x21 (pair2 r2 (rem h (!2 x21 r2)))) x22))))
              (_ Nothing State)))))))
(define-fun
  psafe
    ((x Int) (y Int) (z Int) (x2 Reach)) Bool
    (match (reach x x2)
      (case Nothing true)
      (case (Just s)
        (ite
          (and (<= y x) (and (!2 (safe s) y) (!2 (!2 (isin s) y) z)))
          (= (!2 (owns s) y) (Just z)) true))))
(define-fun
  !!
    ((x (Map (Map Bool))) (y (pair Int Int))) Bool
    (match y (case (pair2 z y2) (!2 (!2 x z) y2))))
(prove (forall ((r Int) (g Int) (q Reach)) (psafe 0 r g q)))
