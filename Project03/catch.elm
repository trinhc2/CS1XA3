import Browser
import Browser.Navigation exposing (Key(..))
import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Url
import String exposing (..)

type Msg = Tick Float GetKeyState
         | MakeRequest Browser.UrlRequest
         | UrlChange Url.Url

type alias Model = { health : Float
                   , score : Float
                   , x : Float
                   , y : Float
                   , rainY : Float
                   , rainX : Float
                   }



init : () -> Url.Url -> Key -> ( Model, Cmd Msg )
init flags url key =
  let
    model = { health = 3, score = 0, x = 0, y = 0, rainY = 150, rainX = 0}
  in ( model , Cmd.none ) -- add init model

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
                     Tick time (keyToState, _, (x,y)) -> ({model | x = if model.x <= -210 then model.x + 1 else if model.x >= 210 then model.x - 1 else model.x + 4*x
                                                                 , rainY = model.rainY - 3}, Cmd.none)


--                     Tick time keystate ->
  --                     let
    --                    newpositiony = model.positiony + model.vy
      --                 in ( { model | positiony = newpositiony }, Cmd.none )
                     MakeRequest req    -> ( model , Cmd.none )
                     UrlChange url      -> ( model , Cmd.none )

view : Model -> { title : String, body : Collage Msg }
view model =
  let
    title = "Missile Command"
    body = collage 500 375 shapes
    shapes = [ assets, catcher |> move (model.x, model.y), rainDrop ]
    assets = group [ background, currentHealth, currentScore, ground]
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
             |> filled orange
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
