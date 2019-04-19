import Browser
import Browser.Navigation exposing (Key(..))
import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Url
import String exposing (..)
import Random exposing (..)
import Html.Attributes exposing (..)
import Html exposing (..)
import Http
import Html.Events exposing (..)
import Json.Decode as JDecode
import Json.Encode as JEncode
import String

rainSpeed = -9
cupSpeed = 4

--rootUrl = "http://localhost:8000/e/trinhc2/"

rootUrl = "https://mac1xa3.ca/e/trinhc2/"

type Msg = Tick Float GetKeyState
         | MakeRequest Browser.UrlRequest
         | UrlChange Url.Url
         | CreateNewX Float
         | StartGame
         | RestartGame
         | NewUserName String
         | NewPassword String
         | RedirectRegister
         | LoginButton
         | GotLoginResponse (Result Http.Error String)
         | RegisterButton
         | GotRegisterResponse (Result Http.Error String)

type alias Model = { health : Float
                   , score : Int
                   , x : Float
                   , y : Float
                   , rainY : Float
                   , rainX : Float
                   , gameState : State
                   , text : String
                   , gameScreen : Screen
                   , username : String
                   , password : String
                   , error : String
                   }

type State = Start | Active | Finish

type Screen = Login | Register | Game

randomX : Random.Generator Float
randomX =
  Random.float -200 200

generateRandomX : Cmd Msg
generateRandomX =
  Random.generate CreateNewX randomX

init : () -> Url.Url -> Key -> ( Model, Cmd Msg )
init flags url key =
  let
    model = { health = 3, score = 0, x = 0, y = 0, rainY = 200, rainX = 0, gameState = Start, text = "Click to begin, A and D to move, J to boost", gameScreen = Login, username = "", password = "", error = ""}
  in ( model , Cmd.none ) -- add init model

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case model.gameState of
                      Active ->
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
                                      if model.health == 0 then ({ model | gameState = Finish, text = "Game over, click to restart"}, Cmd.none) else
                                        ({model | x = if model.x <= -210 then model.x + 1 else if model.x >= 210 then model.x - 1 else model.x + cupSpeed*x*boostx
                                                , rainY = model.rainY + rainSpeed
                                        }, Cmd.none)

                           MakeRequest req    -> ( model , Cmd.none )
                           UrlChange url      -> ( model , Cmd.none )
                           StartGame -> ( model , Cmd.none)
                           CreateNewX newrainx -> ({model | rainX = newrainx}, Cmd.none)
                           RestartGame -> ( model , Cmd.none)
                           NewUserName name -> ( model , Cmd.none )
                           NewPassword pass -> ( model , Cmd.none)
                           RedirectRegister -> ( model , Cmd.none)
                           LoginButton -> ( model , Cmd.none)
                           GotLoginResponse _ -> ( model , Cmd.none)
                           RegisterButton -> ( model , Cmd.none)
                           GotRegisterResponse _ -> ( model , Cmd.none)

                      Finish ->
                          case msg of
                            StartGame -> ( model , Cmd.none)
                            MakeRequest _    -> ( model , Cmd.none )
                            UrlChange _      -> ( model , Cmd.none )
                            Tick _ _ -> ( model , Cmd.none )
                            CreateNewX _ -> ( model , Cmd.none )
                            RestartGame -> ( {model | health = 3, score = 0, x = 0, y = 0, rainY = 200, rainX = 0, gameState = Start, text = "Click to begin, A and D to move, J to boost"} , Cmd.none)
                            NewUserName name -> ( model , Cmd.none )
                            NewPassword pass -> ( model , Cmd.none)
                            RedirectRegister -> ( model , Cmd.none)
                            LoginButton -> ( model , Cmd.none)
                            GotLoginResponse _ -> ( model , Cmd.none)
                            RegisterButton -> ( model , Cmd.none)
                            GotRegisterResponse _ -> ( model , Cmd.none)

                      Start ->
                          case msg of
                              StartGame -> ( {model | gameState = Active, text = ""} , Cmd.none)
                              MakeRequest _    -> ( model , Cmd.none )
                              UrlChange _      -> ( model , Cmd.none )
                              Tick _ _ -> ( model , Cmd.none )
                              CreateNewX _ -> ( model , Cmd.none )
                              RestartGame -> ( model , Cmd.none)
                              NewUserName name -> ( { model | username = name }, Cmd.none )
                              NewPassword pass -> ( { model | password = pass }, Cmd.none )
                              RedirectRegister -> ( { model | gameScreen = Register, username = "", password = ""}, Cmd.none)
                              LoginButton -> ( model, loginPost model )
                              GotLoginResponse result ->
                                  case result of
                                      Ok "LoginFailed" ->
                                          ( { model | error = "failed to login" }, Cmd.none )

                                      Ok _ ->
                                          ( { model | gameScreen = Game}, Cmd.none )

                                      Err error ->
                                          ( handleError model error, Cmd.none )
                              RegisterButton -> ( model , registerPost model)
                              GotRegisterResponse result ->
                                  case result of
                                      Ok _ ->
                                          ( model, Cmd.none )

                                      Err error ->
                                          ( handleError model error, Cmd.none )
view : Model -> { title : String, body : Collage Msg }
view model =
  let
    title = "Fill up my cup"
    body = collage 500 375 screenChange
    screenChange = case model.gameScreen of
                        Game -> gameAssets
                        Login -> loginAssets
                        Register -> registerAssets

--Game graphic elements
    gameAssets = [ ui, rainDrop, ground, catcher |> move (model.x, model.y), gametext]
    ui = group [ background, currentHealth, currentScore]
    catcher = group [ cup, handle, innerhandle]

    background = rectangle 500 375
                  |> filled black
                  |> notifyTap StartGame
                  |> notifyTap RestartGame

    currentHealth = GraphicSVG.text ("Health: " ++ String.fromFloat model.health)
                      |> sansserif
                      |> filled white
                      |> move (-245, 175)

    currentScore = GraphicSVG.text ("Score: " ++ String.fromInt model.score)
                      |> sansserif
                      |> filled white
                      |> move (-245, 160)

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

    gametext = GraphicSVG.text (model.text)
                |> centered
                |> GraphicSVG.size 20
                |> sansserif
                |> filled white

--Login graphic elements
    loginAssets = [loginBg] ++ gameTitle ++ userInput ++ passInput ++ loginButton ++ signupButton
    userInput = [html 250 300 (div [] [input [placeholder "Username", onInput NewUserName, value model.username, Html.Attributes.style "height" "10px", Html.Attributes.style "width" "171px"] []])|> move (-90,20)]
    passInput = [html 250 300 (div [] [input [placeholder "Password", onInput NewPassword, value model.password, Html.Attributes.style "height" "10px", Html.Attributes.style "width" "171px"] []])|> move (-90,0)]
    loginBg = rectangle 250 300
                |> filled blue
    loginButton = [html 250 300 (div [] [button [Html.Events.onClick LoginButton, Html.Attributes.style "height" "20px", Html.Attributes.style "width" "50px"] [Html.text "Login"], Html.text model.error]) |> move (-90,-22)]
    gameTitle = [html 250 300 (div [] [Html.text "Fill Up My Cup"])|> move(-55,50) ]

    signupButton = [html 250 300 (div [] [button [Html.Attributes.style "height" "20px", Html.Attributes.style "width" "125px", onClick RedirectRegister] [Html.text "Create an account"]]) |> move (-40,-22)]

--Register graphic elements
    registerAssets = [loginBg] ++ gameTitle ++ userInput ++ passInput ++ registerButton
    registerButton = [html 250 300 (div [] [button [onClick RegisterButton, Html.Attributes.style "height" "20px", Html.Attributes.style "width" "70px"] [Html.text "Register"]]) |> move (-40,-22)]
  in { title = title , body = body }

--Json Request Functions
userEncoder : Model -> JEncode.Value
userEncoder model =
    JEncode.object
        [ ( "username"
          , JEncode.string model.username
          )
        , ( "password"
          , JEncode.string model.password
          )
        ]

loginPost : Model -> Cmd Msg
loginPost model =
    Http.post
        { url = rootUrl ++ "usersystem/signinuser/"
        , body = Http.jsonBody <| userEncoder model
        , expect = Http.expectString GotLoginResponse
        }

registerPost : Model -> Cmd Msg
registerPost model =
    Http.post
        { url = rootUrl ++ "usersystem/registeruser/"
        , body = Http.jsonBody <| userEncoder model
        , expect = Http.expectString GotRegisterResponse
        }

handleError : Model -> Http.Error -> Model
handleError model error =
    case error of
        Http.BadUrl url ->
            { model | error = "bad url: " ++ url }

        Http.Timeout ->
            { model | error = "timeout" }

        Http.NetworkError ->
            { model | error = "network error" }

        Http.BadStatus i ->
            { model | error = "bad status " ++ String.fromInt i }

        Http.BadBody body ->
            { model | error = "bad body " ++ body }


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
