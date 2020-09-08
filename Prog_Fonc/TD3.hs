-- Type Fonctionnel
type Matf = Int -> Int -> (Bool, Int)

exemple :: Matf
exemple i j | (1 <= i) && (i<= 6) && (1<= j) && (j<= 5) = (True, 2*i+j)
            | otherwise = (False, 0)

identique4x4 :: Matf
identique4x4 i j | (1 <= i) &&  (i<= 4) && (1<= j) && (j<= 4) && i == j = (True,1)
                  | (1 <= i) &&  (i<= 4) && (1<= j) && (j<= 4) && i /= j = (True,0)
                  | otherwise = (False, 0)


nbLines :: Matf -> Int
nbLines f = nbLinesIntern f 1
        where nbLinesIntern f i = case f i 1 of
                                (True, _) -> 1 + nbLinesIntern f (i+1)
                                (False, 0) -> 0


nbCols :: Matf -> Int
nbCols f = nbColsIntern f 1
      where nbColsIntern f j = case f 1 j of
                               (True, _) -> 1 + nbColsIntern f (j+1)
                               (False, 0) -> 0

dims :: Matf -> (Int, Int)
dims x = (nbLines x, nbCols x)

cmpDims :: Matf -> Matf -> Bool
cmpDims x y | nbLines x == nbLines y && nbCols x == nbCols y = True
            | otherwise = False

add :: Matf -> Matf -> Matf
add x y = if not (cmpDims x y)
        then error "Matrix not have same dims"
        else let (l,c) = dims x in
                      (\i j -> if 1 <= i && i <= l && 1 <= j && j <= c
                               then (True, snd(x i j) + snd(y i j))
                               else (False, 0))

import System.IO

getCh :: IO Char
getCh = do
           hSetEcho stdin False
           x <- getChar
           hSetEcho stdin True
           return x


sgetLine ::  IO String
sgetLine = do
             x <- getCh
             if x == '\n'
             then do
                    putChar x
                    return []
             else do
                    putChar '-'
                    xs <- sgetLine
                    return (x:xs)

match :: String -> String -> String
match xs ys =
         [if elem x ys then x else '-' | x <- xs]

play :: String -> IO ()
play mot = do
             xs <- getLine
             if xs == mot
             then putStrLn "Ouai Bravo "
             else do
                  putStrLn (match mot xs)
                  play mot

hangman :: IO ()
hangman = do
            putStrLn "Mot secret : "
            mot <- sgetLine
            putStrLn "Cherches :"
            play mot

data Prop = Const Bool
          | Var Char
          | Not Prop
          | And Prop Prop
          | Imply Prop Prop

p1:: Prop
p1 = And (Var 'A') (Not (Var 'A'))

p2:: Prop
p2 = Imply (And (Var 'A') (Var 'B')) (Var 'A')

p3:: Prop
p3 = Imply (Var 'A') (And (Var 'A') (Var 'B'))

p4:: Prop
p4 = Imply (And (Var 'A') (Imply (Var 'A') (Var 'B'))) (Var 'B')

type Assoc k v = [(k, v)]
type Subst = Assoc Char Bool

find :: Eq k => k -> Assoc k v -> v
find k (x:xs) | k /= (fst x) = find k xs
              | otherwise = snd x

eval:: Subst -> Prop -> Bool
eval _ (Const bool) = bool
eval subst (Var char) = find char subst
eval subst (Not prop) = not (eval subst prop)
eval subst (And p1 p2) = (eval subst p1) && (eval subst p2)
eval subst (Imply p1 p2) = (eval subst p1) <= (eval subst p2)

rmdups:: Eq a => [a] -> [a]
rmdups [] = []
rmdups (x:xs) = x: filter (/=x) (rmdups xs)

vars :: Prop -> [Char]
vars p = rmdups (vars2 p)

vars2 ::  Prop -> [Char]
vars2 (Const bool) = []
vars2 (Var char) = [char]
vars2 (Not prop) = vars2 prop
vars2 (And p1 p2) = vars p1 ++ vars p2
vars2 (Imply p1 p2) = vars p1 ++ vars p2

bools :: Int -> [[Bool]]
bools 0 = [[]]
bools n = map (False :) bss ++ map (True :) bss
        where bss = bools (n-1)

substs :: Prop -> [Subst]
substs p = map (zip vs) (bools(length vs))
         where vs = vars p

isTaut :: Prop -> Bool
isTaut p = and [eval s p | s <- substs p]
