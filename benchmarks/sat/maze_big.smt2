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
  walk
    ((x (list (list Tile))) (y (list Dir)) (z (Pair Nat Nat)))
    (Maybe (Pair Nat Nat))
    (match y
      (case nil (Just z))
      (case (cons d x2)
        (let ((r (off d z)))
          (match (index2D x r)
            (case Nothing (as Nothing (Maybe (Pair Nat Nat))))
            (case (Just x3)
              (match x3
                (case Wall (as Nothing (Maybe (Pair Nat Nat))))
                (case Floor (walk x x2 r))
                (case Treasure (walk x x2 r))
                (case Key (walk x x2 r))
                (case Door (walk x x2 r)))))))))
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
(define-fun
  bigMap
    () (list (list Tile))
    (cons
      (cons Floor
        (cons Floor
          (cons Floor
            (cons Floor
              (cons Floor
                (cons Wall
                  (cons Floor
                    (cons Floor
                      (cons Floor
                        (cons Floor
                          (cons Floor
                            (cons Floor
                              (cons Floor
                                (cons Wall
                                  (cons Floor
                                    (cons Floor
                                      (cons Floor
                                        (cons Floor
                                          (cons Floor (as nil (list Tile)))))))))))))))))))))
      (cons
        (cons Floor
          (cons Wall
            (cons Wall
              (cons Wall
                (cons Floor
                  (cons Wall
                    (cons Floor
                      (cons Wall
                        (cons Wall
                          (cons Wall
                            (cons Floor
                              (cons Wall
                                (cons Wall
                                  (cons Wall
                                    (cons Floor
                                      (cons Wall
                                        (cons Wall
                                          (cons Wall
                                            (cons Floor (as nil (list Tile)))))))))))))))))))))
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
                            (cons Floor
                              (cons Floor
                                (cons Wall
                                  (cons Floor
                                    (cons Floor
                                      (cons Floor
                                        (cons Floor
                                          (cons Floor
                                            (cons Wall
                                              (cons Floor (as nil (list Tile)))))))))))))))))))))
          (cons
            (cons Floor
              (cons Wall
                (cons Wall
                  (cons Wall
                    (cons Wall
                      (cons Wall
                        (cons Floor
                          (cons Wall
                            (cons Floor
                              (cons Wall
                                (cons Wall
                                  (cons Wall
                                    (cons Floor
                                      (cons Wall
                                        (cons Wall
                                          (cons Wall
                                            (cons Wall
                                              (cons Wall
                                                (cons Floor (as nil (list Tile)))))))))))))))))))))
            (cons
              (cons Floor
                (cons Wall
                  (cons Floor
                    (cons Floor
                      (cons Floor
                        (cons Wall
                          (cons Floor
                            (cons Wall
                              (cons Floor
                                (cons Floor
                                  (cons Floor
                                    (cons Floor
                                      (cons Floor
                                        (cons Floor
                                          (cons Floor
                                            (cons Wall
                                              (cons Floor
                                                (cons Floor
                                                  (cons Floor
                                                    (as nil (list Tile)))))))))))))))))))))
              (cons
                (cons Floor
                  (cons Wall
                    (cons Floor
                      (cons Wall
                        (cons Floor
                          (cons Wall
                            (cons Wall
                              (cons Wall
                                (cons Floor
                                  (cons Wall
                                    (cons Wall
                                      (cons Wall
                                        (cons Wall
                                          (cons Wall
                                            (cons Wall
                                              (cons Wall
                                                (cons Floor
                                                  (cons Wall
                                                    (cons Floor
                                                      (as nil (list Tile)))))))))))))))))))))
                (cons
                  (cons Floor
                    (cons Wall
                      (cons Floor
                        (cons Wall
                          (cons Floor
                            (cons Floor
                              (cons Floor
                                (cons Wall
                                  (cons Floor
                                    (cons Wall
                                      (cons Floor
                                        (cons Floor
                                          (cons Floor
                                            (cons Floor
                                              (cons Floor
                                                (cons Floor
                                                  (cons Floor
                                                    (cons Wall
                                                      (cons Floor
                                                        (as nil (list Tile)))))))))))))))))))))
                  (cons
                    (cons Wall
                      (cons Wall
                        (cons Floor
                          (cons Wall
                            (cons Wall
                              (cons Wall
                                (cons Floor
                                  (cons Wall
                                    (cons Wall
                                      (cons Wall
                                        (cons Floor
                                          (cons Wall
                                            (cons Wall
                                              (cons Wall
                                                (cons Wall
                                                  (cons Wall
                                                    (cons Wall
                                                      (cons Wall
                                                        (cons Floor
                                                          (as nil (list Tile)))))))))))))))))))))
                    (cons
                      (cons Floor
                        (cons Floor
                          (cons Floor
                            (cons Wall
                              (cons Floor
                                (cons Wall
                                  (cons Floor
                                    (cons Floor
                                      (cons Floor
                                        (cons Floor
                                          (cons Floor
                                            (cons Wall
                                              (cons Floor
                                                (cons Floor
                                                  (cons Floor
                                                    (cons Floor
                                                      (cons Treasure
                                                        (cons Wall
                                                          (cons Floor
                                                            (as nil (list Tile)))))))))))))))))))))
                      (cons
                        (cons Floor
                          (cons Wall
                            (cons Wall
                              (cons Wall
                                (cons Floor
                                  (cons Wall
                                    (cons Wall
                                      (cons Wall
                                        (cons Wall
                                          (cons Wall
                                            (cons Wall
                                              (cons Wall
                                                (cons Wall
                                                  (cons Wall
                                                    (cons Floor
                                                      (cons Wall
                                                        (cons Wall
                                                          (cons Wall
                                                            (cons Floor
                                                              (as nil
                                                                (list Tile)))))))))))))))))))))
                        (cons
                          (cons Floor
                            (cons Wall
                              (cons Floor
                                (cons Floor
                                  (cons Floor
                                    (cons Floor
                                      (cons Floor
                                        (cons Floor
                                          (cons Floor
                                            (cons Wall
                                              (cons Floor
                                                (cons Floor
                                                  (cons Floor
                                                    (cons Floor
                                                      (cons Floor
                                                        (cons Wall
                                                          (cons Floor
                                                            (cons Floor
                                                              (cons Floor
                                                                (as nil
                                                                  (list Tile)))))))))))))))))))))
                          (cons
                            (cons Wall
                              (cons Wall
                                (cons Floor
                                  (cons Wall
                                    (cons Wall
                                      (cons Wall
                                        (cons Wall
                                          (cons Wall
                                            (cons Floor
                                              (cons Wall
                                                (cons Floor
                                                  (cons Wall
                                                    (cons Wall
                                                      (cons Wall
                                                        (cons Wall
                                                          (cons Wall
                                                            (cons Floor
                                                              (cons Wall
                                                                (cons Wall
                                                                  (as nil
                                                                    (list Tile)))))))))))))))))))))
                            (cons
                              (cons Floor
                                (cons Floor
                                  (cons Floor
                                    (cons Floor
                                      (cons Floor
                                        (cons Wall
                                          (cons Floor
                                            (cons Wall
                                              (cons Floor
                                                (cons Wall
                                                  (cons Floor
                                                    (cons Floor
                                                      (cons Floor
                                                        (cons Wall
                                                          (cons Floor
                                                            (cons Floor
                                                              (cons Floor
                                                                (cons Wall
                                                                  (cons Floor
                                                                    (as nil
                                                                      (list
                                                                        Tile)))))))))))))))))))))
                              (cons
                                (cons Wall
                                  (cons Wall
                                    (cons Wall
                                      (cons Wall
                                        (cons Floor
                                          (cons Wall
                                            (cons Floor
                                              (cons Wall
                                                (cons Floor
                                                  (cons Wall
                                                    (cons Wall
                                                      (cons Wall
                                                        (cons Floor
                                                          (cons Wall
                                                            (cons Floor
                                                              (cons Wall
                                                                (cons Wall
                                                                  (cons Wall
                                                                    (cons Floor
                                                                      (as nil
                                                                        (list
                                                                          Tile)))))))))))))))))))))
                                (cons
                                  (cons Floor
                                    (cons Floor
                                      (cons Floor
                                        (cons Floor
                                          (cons Floor
                                            (cons Wall
                                              (cons Floor
                                                (cons Wall
                                                  (cons Floor
                                                    (cons Wall
                                                      (cons Floor
                                                        (cons Floor
                                                          (cons Floor
                                                            (cons Wall
                                                              (cons Floor
                                                                (cons Wall
                                                                  (cons Floor
                                                                    (cons Floor
                                                                      (cons Floor
                                                                        (as nil
                                                                          (list
                                                                            Tile)))))))))))))))))))))
                                  (cons
                                    (cons Floor
                                      (cons Wall
                                        (cons Wall
                                          (cons Wall
                                            (cons Wall
                                              (cons Wall
                                                (cons Floor
                                                  (cons Wall
                                                    (cons Floor
                                                      (cons Wall
                                                        (cons Floor
                                                          (cons Wall
                                                            (cons Floor
                                                              (cons Wall
                                                                (cons Floor
                                                                  (cons Wall
                                                                    (cons Wall
                                                                      (cons Wall
                                                                        (cons Floor
                                                                          (as nil
                                                                            (list
                                                                              Tile)))))))))))))))))))))
                                    (cons
                                      (cons Floor
                                        (cons Wall
                                          (cons Floor
                                            (cons Floor
                                              (cons Floor
                                                (cons Wall
                                                  (cons Floor
                                                    (cons Floor
                                                      (cons Floor
                                                        (cons Floor
                                                          (cons Floor
                                                            (cons Wall
                                                              (cons Floor
                                                                (cons Wall
                                                                  (cons Floor
                                                                    (cons Wall
                                                                      (cons Floor
                                                                        (cons Floor
                                                                          (cons Floor
                                                                            (as nil
                                                                              (list
                                                                                Tile)))))))))))))))))))))
                                      (cons
                                        (cons Floor
                                          (cons Wall
                                            (cons Floor
                                              (cons Wall
                                                (cons Floor
                                                  (cons Wall
                                                    (cons Wall
                                                      (cons Wall
                                                        (cons Wall
                                                          (cons Wall
                                                            (cons Wall
                                                              (cons Wall
                                                                (cons Wall
                                                                  (cons Wall
                                                                    (cons Floor
                                                                      (cons Wall
                                                                        (cons Floor
                                                                          (cons Wall
                                                                            (cons Floor
                                                                              (as nil
                                                                                (list
                                                                                  Tile)))))))))))))))))))))
                                        (cons
                                          (cons Floor
                                            (cons Floor
                                              (cons Floor
                                                (cons Wall
                                                  (cons Floor
                                                    (cons Floor
                                                      (cons Floor
                                                        (cons Floor
                                                          (cons Floor
                                                            (cons Floor
                                                              (cons Floor
                                                                (cons Floor
                                                                  (cons Floor
                                                                    (cons Floor
                                                                      (cons Floor
                                                                        (cons Floor
                                                                          (cons Floor
                                                                            (cons Wall
                                                                              (cons Floor
                                                                                (as nil
                                                                                  (list
                                                                                    Tile)))))))))))))))))))))
                                          (as nil (list (list Tile)))))))))))))))))))))))
(assert-not
  (forall ((x (list Dir)))
    (not (goal2 bigMap (walk bigMap x (Pair2 Z Z))))))
(check-sat)
