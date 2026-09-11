import Data.Char (isDigit)
-- Primero, para validar esta parte
esCarnetValido :: String -> Bool
esCarnetValido xs = length xs == 8 && all isDigit xs && esPeriodoValido (take 3 xs)

esPeriodoValido :: String -> Bool
esPeriodoValido p = p `elem` ["262", "271", "272", "281", "282", "291", "292"]

-- Donde se formatea el periodo
formatearPeriodo :: String -> String
formatearPeriodo "262" = "2026-2"
formatearPeriodo "271" = "2027-1"
formatearPeriodo "272" = "2027-2"
formatearPeriodo "281" = "2028-1"
formatearPeriodo "282" = "2028-2"
formatearPeriodo "291" = "2029-1"
formatearPeriodo "292" = "2029-2"
formatearPeriodo _     = "Periodo Invalido"

-- La condicion de Nicomaco
sumaAlicuota :: Int -> Int
sumaAlicuota n = sum [x | x <- [1 .. n - 1], n `mod` x == 0]

-- La clasificacion de la categoria pues sector de carrera?
clasificarCategoria :: Int -> String
clasificarCategoria n
    | suma > n  = "Administrative"
    | suma == n = "Engineering"
    | otherwise = "Humanities"
  where
    suma = sumaAlicuota n

-- Consecutivo y Paridad
formatearConsecutivo :: String -> String
formatearConsecutivo cons = "num" ++ show (read cons :: Int)

determinarParidad :: String -> String
determinarParidad carnet
    | even (read carnet :: Integer) = "even"
    | otherwise                     = "odd"

-- La funcion principal "orquestradora"
analizarCarnet :: String -> String
analizarCarnet carnet
    | not (esCarnetValido carnet) = "Error: El carnet ingresado es invalido. Debe tener exactamente 8 digitos y pertenecer a un periodo entre 2026-2 y 2029-2."
    | otherwise = 
        let periodo     = take 3 carnet
            categoria   = take 2 (drop 3 carnet)
            consecutivo = drop 5 carnet
            
            pOut      = formatearPeriodo periodo
            cOut      = clasificarCategoria (read categoria :: Int)
            nOut      = formatearConsecutivo consecutivo
            parityOut = determinarParidad carnet
        in pOut ++ " " ++ cOut ++ " " ++ nOut ++ " " ++ parityOut

-- Punto de entrada
main :: IO ()
main = do
    linea <- getLine
    putStrLn (analizarCarnet linea)
