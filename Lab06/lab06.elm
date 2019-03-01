import Browser
import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (placeholder)

main =
 Browser.sandbox { init = init, update = update, view = view }

-- Model
type alias Model = { textbox : String
                    , anotherTextbox : String }

type Msg = StringEntered String
         | DifferentStringEntered String


init : Model
init = { textbox = "", anotherTextbox = ""}

-- View
view : Model -> Html Msg
view model = div []
              [
                input [ placeholder "String 1", onInput StringEntered ] []
              , input [ placeholder "String 2", onInput DifferentStringEntered] []
              , div [] [ text (model.textbox ++ " : " ++ model.anotherTextbox) ]
              ]

-- Update
update : Msg -> Model -> Model
update msg model = case msg of
                    StringEntered newString -> {model | textbox = newString}
                    DifferentStringEntered newString -> {model | anotherTextbox = newString}
