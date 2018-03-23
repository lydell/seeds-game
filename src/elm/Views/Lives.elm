module Views.Lives exposing (..)

import Data.Transit as Transit exposing (Transit)
import Helpers.Css.Style exposing (..)
import Helpers.Css.Transform exposing (scale, transformStyle)
import Html exposing (..)
import Html.Attributes exposing (..)
import Views.Icons.Heart exposing (..)


livesLeft : Transit Int -> List (Html msg)
livesLeft lifeState =
    let
        lives =
            Transit.val lifeState
    in
        List.range 1 5
            |> List.map (\n -> ( n <= lives, n == lives, n == lives + 1, lifeState ))
            |> List.map life


life : ( Bool, Bool, Bool, Transit Int ) -> Html msg
life ( active, currentLife, breaking, lifeState ) =
    let
        animation =
            if currentLife then
                animationStyle "heartbeat 1s infinite"
            else
                emptyStyle

        visibleHeart =
            if active then
                heart
            else if breaking && Transit.isTransitioning lifeState then
                breakingHeart
            else
                brokenHeart

        adjustScale =
            if active then
                emptyStyle
            else
                transformStyle [ scale 1.11 ]
    in
        div
            [ style
                [ widthStyle 35
                , heightStyle 35
                , marginLeft 10
                , marginRight 10
                , animation
                , adjustScale
                ]
            , class "dib"
            ]
            [ visibleHeart ]
