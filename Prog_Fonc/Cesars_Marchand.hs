-- Sujet : Code César
-- Auteur : Killian Marchand
-- Date : 25 Novembre 2019
-- Code César prennant en compte les caractères en MAJUSCULE, et en minuscule.

import Data.Char

-- Table des fréquences --
table::[Float]
table = [9.42, 1.02, 2.64, 3.39, 15.87, 0.95, 1.04, 0.77, 8.41, 0.89, 0.001, 5.34, 3.24, 7.15, 5.14, 2.86, 1.06, 7.9, 7.26, 6.24, 2.15, 0.001, 0.3, 0.24, 0.32]

let2int:: Char -> Int
let2int c = ord c

int2let:: Int -> Char
int2let c = chr c

-- Decalage de lettre --

shift:: Int -> Char -> Char
shift x c | isUpper c && ((let2int c) + x) <= let2int 'A' = int2let((let2int c) + (x `mod` 26))
          | isUpper c && ((let2int c) + x) >= let2int 'Z' = int2let((let2int c) + x - 26)
          | isLower c = shift x (toUpper c)
          | otherwise = int2let ((let2int c) + x)

-- Encodage du message --

cypher:: Int -> String -> String
cypher x [] = []
cypher x y = [shift x c | c <- y, isLetter c]
--cypher x (y:ys) = (shift x y: cypher x ys)

percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m)*100

-- Compte le nombre d'occurence d'une lettre dans un message --

count :: Char -> String -> Int
count c cs = length [ c' | c' <- cs, c==c']

-- Liste  des fréquences  d’apparition  des  lettres  d’une  chaîne --

freqs::String -> [Float]
freqs m = [percent (count c m) (length m) | c <- ['A'..'Z']]

-- Calcul du X² --

chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [((o-e)^2)/e | (o,e) <- zip os es]

-- Rotation de  n  positions --

rotate:: Int -> [a] -> [a]
rotate x [] = []
rotate x m = drop x m ++ take x m

-- Liste  des positionsd’un  élément --

position:: Eq a => a -> [a] -> [Int]
position x xs = [ i' | (x', i') <- zip xs [0..n], x==x' ]
                 where n = length xs - 1

-- Decryptage d'un message --

crack :: String -> String
crack xs = cypher (-factor) xs
      where factor = head(position(minimum chitab)chitab)
            chitab = [ chisqr (rotate n table') table | n <- [0..25] ]
            table' = freqs xs
