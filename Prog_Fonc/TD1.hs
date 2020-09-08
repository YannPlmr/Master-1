qsort :: Ord a => [a] -> [a]-- Prend une liste de type a et retourne une liste de type a
qsort [] = []               -- 1ère équation : retourne liste vide si
                               --appliquée sur une liste vide
                            -- 2ème équation : retourne une liste triée

qsort (x : xs) = qsort smaller ++ [x] ++ qsort larger
      where smaller = [a | a <- xs, a <= x]
            larger   = [a | a <- xs, a > x]

sumcarre = sum [x*x | x <- [1..100]]

replic a b = [b | x <- [1..a]]

pyths n = [ (a,b,c) | c <- [1..n] , b <- [1..n] , a <- [1..n],
                      a == n || b == n || c == n,
                      a^2+b^2==c^2 || a^2-c^2==b^2 || b^2-c^2==a^2 

fonc :: Eq a => a -> a -> a -> a -> Bool
fonc a b c d | a == b && a == c && a == d && b == c && b == d && c == d = True
             | otherwise = False

fonc2 :: Ord a => a -> a -> a -> a -> a
fonc2 a b c d | a > b && a > c && a > d = a
              | b > a && b > c && b > d = b
              | c > a && c > c && c > d = c
              | otherwise = d

domino2Match :: Domino -> Domino -> Bool
domino2Match (w,x) (y,z) | w == y || w == z && x == y || x == z = True
                     | otherwise = False

domino2Construct :: Domino -> Domino -> Domino
domino2Construct (w,x) (y,z)
      | y == w = (x,z)
      | y == z = (x,w)
      | x == w = (y,z)
      | x == z = (y,w)

domino3Match :: Domino -> Domino -> Domino -> Bool
domino3Match d1 d2 d3 =
            (domino2Match d1 d2 && domino2Match d3 (domino2Construct d1 d2))
         || (domino2Match d2 d3 && domino2Match d1 (domino2Construct d2 d3))
         || (domino2Match d1 d3 && domino2Match d2 (domino2Construct d1 d3))

d1 = (2,3) :: Domino
d2 = (2,4) :: Domino
d3 = (1,3) :: Domino

data Parfum = Chocolat | Vanille | Framboise
    deriving Show

prixParfum :: Parfum -> Double
prixParfum Chocolat = 1.5
prixParfum Vanille = 1.2
prixParfum Framboise = 1.4

data Glace = uneBoule Parfum
            | deuxGlace Parfum Parfum
            | troisGlace Parfum Parfum Parfum
    deriving Show

prixGlace :: Glace -> Double
prixGlace (uneBoule x) = 0.1 + prixParfum x
prixGlace (deuxBoule x y) = sum (0.15 : (map prixParfum (x:y:[])))
prixGlace (troisBoule x y z) = sum (0.20 : (map prixParfum (x:y:z:[])))

inverse [] = []
inverse (x:xs) = inverse xs ++ [x]

isPalindrome:: Eq a => [a] -> Bool
isPalindrome xs | 1 >= length xs = False
isPalindrome xs = xs == inverse xs

doPalindrome :: [a] -> [a]
doPalindrome xs = init xs ++ inverse xs
