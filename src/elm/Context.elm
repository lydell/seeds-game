module Context exposing
    ( Context
    , Menu(..)
    , cacheCurrentLives
    , clearCurrentLevel
    , closeMenu
    , decrementLife
    , disableMenu
    , hideLoadingScreen
    , incrementMessageIndex
    , incrementProgress
    , openMenu
    , setCurrentLevel
    , setWindow
    , showLoadingScreen
    , updateLives
    )

import Config.Level as Level
import Level.Progress as Progress exposing (Progress)
import Lives exposing (Lives)
import Ports exposing (cacheLives)
import Time
import View.LoadingScreen as LoadingScreen exposing (LoadingScreen)
import Window exposing (Window)


type alias Context =
    { window : Window
    , loadingScreen : LoadingScreen
    , progress : Progress
    , lives : Lives
    , successMessageIndex : Int
    , menu : Menu
    }


incrementMessageIndex : Context -> Context
incrementMessageIndex context =
    { context | successMessageIndex = context.successMessageIndex + 1 }


setWindow : Int -> Int -> Context -> Context
setWindow width height context =
    { context | window = Window width height }



-- Progress


setCurrentLevel : Level.Id -> Context -> Context
setCurrentLevel level context =
    { context | progress = Progress.setCurrentLevel level context.progress }


clearCurrentLevel : Context -> Context
clearCurrentLevel context =
    { context | progress = Progress.clearCurrentLevel context.progress }


incrementProgress : Level.Worlds -> Context -> Context
incrementProgress allLevels context =
    { context | progress = Progress.handleIncrement allLevels context.progress }



-- Lives


updateLives : Time.Posix -> Context -> Context
updateLives now context =
    { context | lives = Lives.update now context.lives }


decrementLife : Context -> Context
decrementLife context =
    { context | lives = Lives.decrement context.lives }


cacheCurrentLives : Context -> Cmd msg
cacheCurrentLives context =
    context.lives
        |> Lives.toCache
        |> cacheLives



-- Menu


type Menu
    = Open
    | Closed
    | Disabled


openMenu : Context -> Context
openMenu context =
    { context | menu = Open }


closeMenu : Context -> Context
closeMenu context =
    { context | menu = Closed }


disableMenu : Context -> Context
disableMenu context =
    { context | menu = Disabled }



-- Loading Screen


showLoadingScreen : LoadingScreen -> Context -> Context
showLoadingScreen loadingScreen context =
    { context | loadingScreen = loadingScreen }


hideLoadingScreen : Context -> Context
hideLoadingScreen context =
    { context | loadingScreen = LoadingScreen.hidden }
