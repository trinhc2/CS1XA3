import Browser
import Browser.Navigation exposing (Key(..))
import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Url
import String exposing (..)
import Random exposing (..)

type Msg = Tick Float GetKeyState
         | MakeRequest Browser.UrlRequest
         | UrlChange Url.Url
         | CreateNewX Float
         | StartGame
         | RestartGame

type alias Model = { health : Float
                   , score : Float
                   , x : Float
                   , y : Float
                   , rainY : Float
                   , rainX : Float
                   , gameState : State
                   }

type State = Start | Active | Finish
randomX : Random.Generator Float
randomX =
  Random.float -200 200

generateRandomX : Cmd Msg
generateRandomX =
  Random.generate CreateNewX randomX

init : () -> Url.Url -> Key -> ( Model, Cmd Msg )
init flags url key =
  let
    model = { health = 3, score = 0, x = 0, y = 0, rainY = 200, rainX = 0, gameState = Start}
  in ( model , Cmd.none ) -- add init model

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = if model.gameState == Active then
                    case msg of
                     Tick time (keyToState, _, (x,y)) ->
                       let
                        boostx = case keyToState (Key "j") of
                          Down -> 3
                          _ -> 1
                       in
                          if model.rainY < -250
                              then ({ model | rainY = 250
                                            , health = model.health - 1}, generateRandomX)
                          else
                              if (model.rainX - model.x < 40 && model.rainX - model.x > -40)  && ((model.rainY - 7.5) - (model.y - 130) < 10 && (model.rainY - 7.5) - (model.y - 130) > -10)
                                  then ({ model | rainY = 250
                                                , score = model.score + 1}, generateRandomX)
                              else
                                if model.health == 0 then ({ model | gameState = Finish}, Cmd.none) else
                                  ({model | x = if model.x <= -210 then model.x + 1 else if model.x >= 210 then model.x - 1 else model.x + 4*x*boostx
                                          , rainY = model.rainY - 9
                                  }, Cmd.none)

                     MakeRequest req    -> ( model , Cmd.none )
                     UrlChange url      -> ( model , Cmd.none )
                     StartGame -> ( model , Cmd.none)
                     CreateNewX newrainx -> ({model | rainX = newrainx}, Cmd.none)
                     RestartGame -> ( model , Cmd.none)

                    else if model.gameState == Finish then
                      case msg of
                        StartGame -> ( model , Cmd.none)
                        MakeRequest _    -> ( model , Cmd.none )
                        UrlChange _      -> ( model , Cmd.none )
                        Tick _ _ -> ( model , Cmd.none )
                        CreateNewX _ -> ( model , Cmd.none )
                        RestartGame -> ( {model | health = 3, score = 0, x = 0, y = 0, rainY = 200, rainX = 0, gameState = Start} , Cmd.none)
                        else
                          case msg of
                            StartGame -> ( {model | gameState = Active} , Cmd.none)
                            MakeRequest _    -> ( model , Cmd.none )
                            UrlChange _      -> ( model , Cmd.none )
                            Tick _ _ -> ( model , Cmd.none )
                            CreateNewX _ -> ( model , Cmd.none )
                            RestartGame -> ( model , Cmd.none)

view : Model -> { title : String, body : Collage Msg }
view model =
  let
    title = "Fill up my cup"
    body = collage 500 375 shapes
    shapes = [ assets, rainDrop, ground, catcher |> move (model.x, model.y)]
    assets = group [ background, currentHealth, currentScore]
    catcher = group [ cup, handle, innerhandle]

    background = rectangle 500 375
                  |> filled black
                  |> notifyTap StartGame
                  |> notifyTap RestartGame

    currentHealth = text ("Health: " ++ String.fromFloat model.health)
                      |>filled white
                      |>move (-245, 175)

    currentScore = text ("Score: " ++ String.fromFloat model.score)
                      |>filled white
                      |>move (-245, 160)

    ground = rectangle 500 20
             |> filled green
             |> move (0,-180)

    cup = rectangle 75 50
              |> filled red
              |> move (0, -145)

    handle = curve (0,0) [Pull (40,-20) (0,-40)]
              |>filled red
              |>move (35,-125)

    innerhandle = curve (0,0) [Pull (40,-20) (0,-40)]
              |>filled black
              |>scale 0.5
              |>move (40,-135)
              
    rainDrop = circle 15
                |> filled blue
                |> move (model.rainX,model.rainY)



  in { title = title , body = body }

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : AppWithTick () Model Msg
main = appWithTick Tick
       { init = init
       , update = update
       , view = view
       , subscriptions = subscriptions
       , onUrlRequest = MakeRequest
       , onUrlChange = UrlChange
       }
