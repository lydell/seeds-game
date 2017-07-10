module Data.Block exposing (..)

import Dict
import Model exposing (..)


addWalls : List Coord -> Board -> Board
addWalls coords board =
    List.foldl (\coords currentBoard -> Dict.update coords (Maybe.map (always Wall)) currentBoard) board coords


getTileState : Block -> TileState
getTileState =
    fold identity Empty


map : (TileState -> TileState) -> Block -> Block
map fn block =
    case block of
        Wall ->
            Wall

        Space tileState ->
            Space <| fn tileState


fold : (TileState -> a) -> a -> Block -> a
fold fn acc block =
    case block of
        Wall ->
            acc

        Space tileState ->
            fn tileState
