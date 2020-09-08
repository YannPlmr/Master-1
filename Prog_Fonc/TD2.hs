import Prelude hiding(product, lenght, init, (++), drop, take, halve)

-- EXERCICE 1

product :: Num a => [a] -> a
product [] = 1
product (x:xs) = x * product xs


lenght :: [a] -> Int
lenght [] = 0
lenght (_:xs) = 1 + lenght xs

init :: [a] -> [a]
init (_:[]) = []
init (x:xs) = x:init xs

conca :: [a]->[a]->[a]
conca [] x = x
conca (x:xs) a = x:conca xs a

insert :: Ord a => a->[a]->[a]
insert x [] = [x]
insert x (y:ys) | x <= y = x:y:ys
                | otherwise = y : (insert x ys)

isort :: Ord a => [a] -> [a]
isort [] = []
isort (x:xs) = insert x (isort xs)

-- EXERCICE 2

paire :: Int -> Bool
paire 0 = True
paire 1 = False
paire a = impaire (a-1)

impaire :: Int -> Bool
impaire 0 = False
impaire 1 = True
impaire a = paire (a-1)

drop :: [a] -> Int -> [a]
drop [] n = []
drop x 0 = x
drop (x:xs) n = drop xs (n-1)

take :: [a] -> Int -> [a]
take [] x = []
take x 0 = []
take (x:xs) n = x:take xs (n-1)

halve :: [a] -> ([a],[a])
halve [] = ([],[])
halve x = (take x (quot (length x) 2), drop x (quot (length x) 2))
-- halve x = (take x n, drop x n)
--          where (length x) `div` 2

merge :: Ord a => [a] -> [a] -> [a]
merge x y = isort (conca x y)

--merge :: Ord a => [a] -> [a] -> [a]
--merge x [] = x
--merge [] x = x
--merge (x:xs) (y:ys) | x<=y = x:merge xs (y:ys)
--                    | otherwise = y:merge (x:xs) ys

msort :: Ord a => [a] -> [a]
msort [] = []
msort x = merge (fst(halve x)) (snd(halve x))
