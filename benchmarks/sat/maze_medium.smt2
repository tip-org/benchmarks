(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Tile (Wall) (Floor) (Treasure) (Key) (Door))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(declare-datatypes () ((Dir (U) (D) (L) (R))))
(define-fun
  q ((x Nat)) Nat
    (match x
      (case Z Z)
      (case (S n) n)))
(define-fun
  off
    ((x Dir) (y (Pair Nat Nat))) (Pair Nat Nat)
    (match x
      (case U (match y (case (Pair2 z y2) (Pair2 z (q y2)))))
      (case D (match y (case (Pair2 x2 y3) (Pair2 x2 (S y3)))))
      (case L (match y (case (Pair2 x3 y4) (Pair2 (q x3) y4))))
      (case R (match y (case (Pair2 x4 y5) (Pair2 (S x4) y5))))))
(define-fun
  mediumMap
    () (list (list Tile))
    (cons
      (cons Floor
        (cons Floor
          (cons Floor
            (cons Floor
              (cons Floor
                (cons Wall
                  (cons Key
                    (cons Wall
                      (cons Floor (cons Floor (cons Floor (as nil (list Tile)))))))))))))
      (cons
        (cons Wall
          (cons Wall
            (cons Floor
              (cons Wall
                (cons Floor
                  (cons Wall
                    (cons Floor
                      (cons Wall
                        (cons Floor (cons Wall (cons Floor (as nil (list Tile)))))))))))))
        (cons
          (cons Floor
            (cons Floor
              (cons Floor
                (cons Wall
                  (cons Floor
                    (cons Wall
                      (cons Floor
                        (cons Floor
                          (cons Floor (cons Wall (cons Floor (as nil (list Tile)))))))))))))
          (cons
            (cons Floor
              (cons Wall
                (cons Wall
                  (cons Wall
                    (cons Floor
                      (cons Wall
                        (cons Wall
                          (cons Wall
                            (cons Wall (cons Wall (cons Floor (as nil (list Tile)))))))))))))
            (cons
              (cons Floor
                (cons Wall
                  (cons Floor
                    (cons Wall
                      (cons Floor
                        (cons Floor
                          (cons Floor
                            (cons Floor
                              (cons Floor (cons Floor (cons Floor (as nil (list Tile)))))))))))))
              (cons
                (cons Floor
                  (cons Wall
                    (cons Floor
                      (cons Wall
                        (cons Wall
                          (cons Wall
                            (cons Wall
                              (cons Wall
                                (cons Wall (cons Wall (cons Floor (as nil (list Tile)))))))))))))
                (cons
                  (cons Floor
                    (cons Wall
                      (cons Floor
                        (cons Floor
                          (cons Floor
                            (cons Floor
                              (cons Floor
                                (cons Floor
                                  (cons Floor (cons Wall (cons Floor (as nil (list Tile)))))))))))))
                  (cons
                    (cons Wall
                      (cons Wall
                        (cons Floor
                          (cons Wall
                            (cons Door
                              (cons Wall
                                (cons Wall
                                  (cons Wall
                                    (cons Floor
                                      (cons Wall (cons Floor (as nil (list Tile)))))))))))))
                    (cons
                      (cons Floor
                        (cons Floor
                          (cons Floor
                            (cons Wall
                              (cons Floor
                                (cons Floor
                                  (cons Floor
                                    (cons Wall
                                      (cons Floor
                                        (cons Wall (cons Floor (as nil (list Tile)))))))))))))
                      (cons
                        (cons Floor
                          (cons Wall
                            (cons Wall
                              (cons Wall
                                (cons Wall
                                  (cons Wall
                                    (cons Floor
                                      (cons Wall
                                        (cons Wall
                                          (cons Wall (cons Floor (as nil (list Tile)))))))))))))
                        (cons
                          (cons Floor
                            (cons Floor
                              (cons Floor
                                (cons Floor
                                  (cons Treasure
                                    (cons Wall
                                      (cons Floor
                                        (cons Floor
                                          (cons Floor
                                            (cons Floor (cons Floor (as nil (list Tile)))))))))))))
                          (as nil (list (list Tile)))))))))))))))
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
(define-fun
  (par (a)
    (index2D
       ((x (list (list a))) (y (Pair Nat Nat))) (Maybe a)
       (match y
         (case (Pair2 z y2)
           (match (index x y2)
             (case Nothing (as Nothing (Maybe a)))
             (case (Just xs) (index xs z))))))))
(define-fun-rec
  walkKeychain
    ((x (list (list Tile))) (y Bool) (z (list Dir))
     (x2 (Pair Nat Nat)))
    (Maybe (Pair Nat Nat))
    (match z
      (case nil (Just x2))
      (case (cons d x3)
        (let ((r (off d x2)))
          (match (index2D x r)
            (case Nothing (as Nothing (Maybe (Pair Nat Nat))))
            (case (Just x4)
              (match x4
                (case Wall (as Nothing (Maybe (Pair Nat Nat))))
                (case Floor (walkKeychain x y x3 r))
                (case Treasure (walkKeychain x y x3 r))
                (case Key (walkKeychain x true x3 r))
                (case Door
                  (ite
                    y (walkKeychain x true x3 r)
                    (as Nothing (Maybe (Pair Nat Nat))))))))))))
(define-fun
  goal2
    ((x (list (list Tile))) (y (Maybe (Pair Nat Nat)))) Bool
    (match y
      (case Nothing false)
      (case (Just r)
        (match (index2D x r)
          (case Nothing false)
          (case (Just z)
            (match z
              (case default false)
              (case Treasure true)))))))
(assert-not
  (forall ((x (list Dir)))
    (not
      (goal2 mediumMap (walkKeychain mediumMap false x (Pair2 Z Z))))))
(check-sat)
