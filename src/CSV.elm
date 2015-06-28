module CSV
  ( isValid
  ) where

import Char exposing (isDigit)
import List exposing (member)
import Parser exposing (..)
import Parser.Char exposing (between)
import Result.Extra exposing (isOk)

type Cell = Cell (List Char)
type Line = Line (List Cell)
type CSV = CSV (List Line)

isValid : String -> Bool
isValid = isOk << parse csvParser

csvParser : Parser CSV
csvParser = CSV `map` many line <* end

line : Parser Line
line = Line `map` (quotedCell <|> cell) `separatedBy` comma <* eol

comma : Parser Char
comma = satisfy (\c -> c == ',')

eol : Parser Char
eol = satisfy (\c -> c == '\n')

noneOf : List Char -> Parser Char
noneOf cs = satisfy (\c -> not <| c `member` cs)

-- TODO Use from parser library when published
{-| Parse a parser between quotes `"` and `"`-}
quoted : Parser result -> Parser result
quoted = between '"' '"'

quotedCell : Parser Cell
quotedCell = Cell `map` (quoted <| many quotedChar)

quotedChar : Parser Char
quotedChar = noneOf ['"'] <|> symbol '"' *> symbol '"'

cell : Parser Cell
cell = Cell `map` (many <| noneOf [',', '\n', '\r', '"'])
