module Views.Hub.World exposing (..)

import Config.Levels exposing (allLevels)
import Data.Board.Types exposing (..)
import Data.InfoWindow exposing (InfoWindow(Hidden))
import Data.Level.Progress exposing (completedLevel, getLevelNumber, reachedLevel)
import Data.Level.Types exposing (..)
import Dict
import Helpers.Html exposing (emptyProperty)
import Helpers.Css.Style exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Scenes.Tutorial.Types as Tu
import Types exposing (Model, Msg(..))
import Views.Seed.All exposing (renderSeed)


renderWorlds : Model -> List (Html Msg)
renderWorlds model =
    allLevels
        |> Dict.toList
        |> List.reverse
        |> List.map (renderWorld model)


renderWorld : Model -> ( WorldNumber, WorldData Tu.Config ) -> Html Msg
renderWorld model (( _, worldData ) as world) =
    div [ style [ backgroundColor worldData.background ], class "pa5 flex" ]
        [ div
            [ style [ widthStyle 300 ], class "center" ]
            (worldData.levels
                |> Dict.toList
                |> List.reverse
                |> List.map (renderLevel model world)
            )
        ]


renderLevel : Model -> ( WorldNumber, WorldData Tu.Config ) -> ( LevelNumber, LevelData Tu.Config ) -> Html Msg
renderLevel model ( world, worldData ) ( level, levelData ) =
    let
        levelNumber =
            getLevelNumber ( world, level ) allLevels
    in
        div
            [ showInfo ( world, level ) model
            , class "tc pointer"
            , id <| "level-" ++ (toString levelNumber)
            , styles
                [ [ widthStyle 35
                  , marginTop 50
                  , marginBottom 50
                  , color worldData.textColor
                  ]
                , offsetStyles level
                ]
            ]
            [ renderIcon ( world, level ) worldData.seedType model
            , renderNumber levelNumber ( world, level ) worldData model
            ]


offsetStyles : Int -> List Style
offsetStyles levelNumber =
    let
        center =
            [ ( "margin-left", "auto" )
            , ( "margin-right", "auto" )
            ]

        right =
            [ ( "margin-left", "auto" ) ]

        left =
            []

        offsetSin =
            toFloat (levelNumber - 1)
                |> (*) 90
                |> degrees
                |> sin
                |> round
    in
        if offsetSin == 0 then
            center
        else if offsetSin == 1 then
            right
        else
            left


renderNumber : Int -> ( WorldNumber, LevelNumber ) -> WorldData Tu.Config -> Model -> Html Msg
renderNumber visibleLevelNumber currentLevel worldData model =
    if reachedLevel allLevels currentLevel model.progress then
        div
            [ class "br-100 center flex justify-center items-center"
            , style
                [ backgroundColor worldData.textBackgroundColor
                , marginTop 10
                , widthStyle 25
                , heightStyle 25
                ]
            ]
            [ p [ style [ color worldData.textCompleteColor ], class "f6" ] [ text <| toString visibleLevelNumber ] ]
    else
        p [ style [ color worldData.textColor ] ] [ text <| toString visibleLevelNumber ]


showInfo : Progress -> Model -> Attribute Msg
showInfo currentLevel model =
    if reachedLevel allLevels currentLevel model.progress && model.levelInfoWindow == Hidden then
        onClick <| ShowInfo currentLevel
    else
        emptyProperty


handleStartLevel : Progress -> Model -> Attribute Msg
handleStartLevel currentLevel model =
    if reachedLevel allLevels currentLevel model.progress then
        onClick <| StartLevel currentLevel
    else
        emptyProperty


renderIcon : ( WorldNumber, LevelNumber ) -> SeedType -> Model -> Html Msg
renderIcon currentLevel seedType model =
    if completedLevel allLevels currentLevel model.progress then
        renderSeed seedType
    else
        renderSeed GreyedOut
