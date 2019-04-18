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

type alias Model = { health : Float
                   , score : Float
                   , x : Float
                   , y : Float
                   , rainY : Float
                   , rainX : Float
                   }

randomX : Random.Generator Float
randomX =
  Random.float -200 200

generateRandomX : Cmd Msg
generateRandomX =
  Random.generate CreateNewX randomX

init : () -> Url.Url -> Key -> ( Model, Cmd Msg )
init flags url key =
  let
    model = { health = 3, score = 0, x = 0, y = 0, rainY = 200, rainX = 0}
  in ( model , Cmd.none ) -- add init model

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
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

                         if (model.rainX - model.x < 40 && model.rainX - model.x > -40)  && ((model.rainY - 7.5) - (model.y - 130) < 10)
                           then ({ model | rainY = 250
                                , score = model.score + 1}, generateRandomX)

                         else
                          ({model | x = if model.x <= -210 then model.x + 1 else if model.x >= 210 then model.x - 1 else model.x + 4*x*boostx
                                  , rainY = model.rainY - 9
                          }, Cmd.none)

--                     Tick time keystate ->
  --                     let
    --                    newpositiony = model.positiony + model.vy
      --                 in ( { model | positiony = newpositiony }, Cmd.none )
                     MakeRequest req    -> ( model , Cmd.none )
                     UrlChange url      -> ( model , Cmd.none )
                     CreateNewX newrainx -> ({model | rainX = newrainx}, Cmd.none)
view : Model -> { title : String, body : Collage Msg }
view model =
  let
    title = "Missile Command"
    body = collage 500 375 shapes
    shapes = [ assets, rainDrop, ground, catcher |> move (model.x, model.y) ]
    assets = group [ background, currentHealth, currentScore]
    catcher = group [ stick, plate]

    background = rectangle 500 375
                  |> filled black

    currentHealth = text ("Health: " ++ String.fromFloat model.health)
                      |>filled white
                      |>move (-245, 175)

    currentScore = text ("Score: " ++ String.fromFloat model.score)
                      |>filled white
                      |>move (-245, 160)

    ground = rectangle 500 20
             |> filled green
             |> move (0,-180)

    stick = rectangle 4 40
                |> filled red
                |> move (0,-150)

    plate = curve (-40,0) [Pull (0,-30) (40,0)]
              |> filled red
              |> move (0,-120)

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
