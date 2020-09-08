-- Sujet : Code TitTacToe
-- Auteur : Killian Marchand
-- Date : 26 Novembre 2019
-- Jeu du morpion

import Data.Char
import Data.List
import System.IO
import Prelude hiding (show)

-- Définition de la taille de la grille

size :: Int
size = 3 -- On fixe ici globalement la taille de la grille

-- Définition d'un joueur

data Player = O | X | B
     deriving (Eq, Ord)

show :: Player  -> String
show O = " O "
show X = " X "
show B = "   "

type Grid = [[Player]] -- La grille est une liste de lignes

next :: Player -> Player
next X = O
next O = X
next B = B

empty :: Grid
empty = replicate size (replicate size B)

full :: Grid -> Bool
full g = all(\x -> x == X || x == O) (concat g)

diag :: Grid -> [Player]
diag g = [g !! i !! i | i<-[0..size-1]]

wins :: Player -> Grid -> Bool
wins p g = any (all (==p)) (g ++ transpose g ++ [diag g, diag (map reverse g)])

won :: Grid -> Bool
won g = wins X g || wins O g

----- Affichage de la grille

insVert :: [String] -> [String]
insVert [x] = [x]
insVert (x:xs) = (x:"|":insVert xs)

insHoriz :: [String]
insHoriz = ["---" | _ <- [0..size-1]] ++ ["-" | _ <- [0..size-2]]

showRow :: [Player] -> [String]
showRow [x] = [show x]
showRow (x:xs) = show x : "|" : showRow xs

showGrid :: Grid -> IO()
showGrid [] = putStr []
showGrid [x] = do
                 putStr (concat (showRow x))
                 putChar '\n'
showGrid (g:gs) = do
                   putStr (concat (showRow g))
                   putChar '\n'
                   putStr (concat insHoriz)
                   putChar '\n'
                   showGrid gs

-- Modification de la grille

valid :: Grid -> Int -> Bool
valid g x = 0 <= x && x < size^2 && concat g !! x ==B

cut :: Int -> [a] -> [[a]]
cut n [] = []
cut n x = take n x : (cut n (drop n x))

move :: Grid -> Int -> Player -> [Grid]
move g x p = if valid g x
                then [cut size (xs ++ [p] ++ ys)]
                else []
          where
               xs = take (x) (concat g)
               ys = drop (x+1) (concat g)

-- Human VS Human

cls :: IO ()
cls = putStr "\ESC[2J"

goto :: (Int, Int) -> IO ()
goto (x,y) = putStr""-- ("\ESC[" ++ show y ++ ";" ++ show x ++ "H")
-- La fonction show ci dessus n'est pas valide puisqu'elle est réecrite par show avec des player

run :: Grid -> Player -> IO ()
run g p = do cls                -- clear screen
             goto (1,1)         -- go to the upper left position
             showGrid g
             run' g p

getNat :: String -> IO Int
getNat message =
                do putStr message
                   xs <- getLine
                   if xs /= [] && all isDigit xs
                      then return (read xs)
                      else do putStrLn "Error: invalid number"
                              getNat message

tictactoe :: IO ()
tictactoe = run empty O

prompt :: Player -> String
prompt p = "Player " ++ show p ++ ", enter your move: "


run' :: Grid -> Player -> IO ()
run' g p | wins O g = putStrLn "Player O wins!\n"
         | wins X g = putStrLn "Player X wins!\n"
         | full g = putStrLn "It's a draw!\n"
         | otherwise =
                      do
                        i <- getNat (prompt p)
                        case move g i p of
                            [] -> do
                                    putStrLn "Error: invalid move"
                                    run' g p
                            [g'] -> run g' (next p)
