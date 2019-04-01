import Browser
import Html exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (placeholder, value, type_, width, height, size, style, src, class, attribute)
import String exposing (..)

main =
 Browser.sandbox { init = init, update = update, view = view }


stylesheet =
    let
        tag =
            "link"

        attrs =
            [ attribute "Rel" "stylesheet"
            , attribute "property" "stylesheet"
            , attribute "href" "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
            ]

        children =
            []
    in
        node tag attrs children

-- Model
type alias Model = { taskList : List Task
                   , task : String
                   , featList : List Task
                   , currentDay : Day}

type alias Task = { taskName : String
                   , taskDay : Day
                  , visible : String}

type Day = Sunday
         | Monday
         | Tuesday
         | Wednesday
         | Thursday
         | Friday
         | Saturday

type Msg = Add
         | TaskEntered String
         | Clear
         | DeleteTask String Day
         | HighlightTask String
         | UnHighlightTask String
         | DayChange Day

--original map needs a list of strings, not a list of tasks


mapFeatTask : Task -> (Html Msg)
mapFeatTask task =
  p [style "font-size" "25px", class "text-break", style "visibility" task.visible]

    [ img [src "filledstar.png", width 25, height 25, style "position" "relative", style "bottom" "3px", onClick (UnHighlightTask task.taskName)] []
    , img [src "trash.png", width 25, height 25, style "margin-left" "5px", style "margin-right" "5px", style "position" "relative", style "bottom" "3px", onClick (DeleteTask task.taskName task.taskDay)] []
    , text task.taskName ]

mapGenTask : Task -> (Html Msg)
mapGenTask task =
  p [style "font-size" "25px", class "text-break", style "visibility" task.visible]

    [ img [src "blankstar.png", width 25, height 25, style "position" "relative", style "bottom" "3px", onClick (HighlightTask task.taskName)] []
    , img [src "trash.png", width 25, height 25, style "margin-left" "5px", style "margin-right" "5px", style "position" "relative", style "bottom" "3px", onClick (DeleteTask task.taskName task.taskDay)] []
    , text task.taskName ]

init : Model
init  = { taskList = []
        , task = ""
        , featList = []
        , currentDay = Sunday}

-- View
view : Model -> Html Msg
view model = div []
             [stylesheet,
             h1 [class "jumbotron jumbotron-fluid display-4"] [text "To-Do List", h6 [class "lead"] [text "A WebApp by Christian T. for CS1XA3, List starts at Sunday by default"]]
             ,
                div [class "p-3 mb-2 bg-light text-dark"]
                [
                --needed value model.task so that upon adding the task box gets ckeared
                input [placeholder "Enter a task", onInput TaskEntered, value model.task, size 53, style "margin-right" "5px"] []
                , button [onClick Add, class "btn btn-primary", style "margin-right" "5px"]                                    [text "Add Task"]
                , button [onClick Clear, class "btn btn-danger"]                                                               [text "Clear all tasks"]
                --not sure why we need the lambda function, because it makes it so we return html and msg
                -- ul [] [tasklist] gives the value List String but ul needs it to be list Html msg
                ],

                div [] --Date Buttons
                [
                 button [class "btn btn-outline-primary", style "margin-left" "15px", style "margin-right" "5px", onClick (DayChange Sunday)] [text "Sunday"]
                ,button [class "btn btn-outline-secondary", style "margin-right" "5px", onClick (DayChange Monday)]                           [text "Monday"]
                ,button [class "btn btn-outline-success", style "margin-right" "5px", onClick (DayChange Tuesday)]                            [text "Tuesday"]
                ,button [class "btn btn-outline-danger", style "margin-right" "5px", onClick (DayChange Wednesday)]                           [text "Wednesday"]
                ,button [class "btn btn-outline-warning", style "margin-right" "5px", onClick (DayChange Thursday)]                           [text "Thursday"]
                ,button [class "btn btn-outline-info", style "margin-right" "5px", onClick (DayChange Friday)]                                [text "Friday"]
                ,button [class "btn btn-outline-dark", onClick (DayChange Saturday)]                                                          [text "Saturday"]
                ],


                div [class "border", style "margin-top" "10px"] --Lists
                [
                 h1 [] [text "Featured"],
                 ul [] (List.map mapFeatTask (model.featList))

                , h1 [] [text "General"]
                , ul [] (List.map mapGenTask (model.taskList))

               ]
            ]

-- Update
update : Msg -> Model -> Model
update msg model = case msg of
                    TaskEntered newTask -> {model | task = newTask}

                    Add -> { model | taskList = { taskName = model.task, taskDay = model.currentDay, visible = "visible"} :: model.taskList
                                   , task = ""}

                    Clear -> {model | taskList = []
                                    , featList = []}
--a monday, a tuesday, delete a -> a is xtask, monday is xtaskdau

                    --filters list, includes everything that does not have the same name as the x'd task
                    DeleteTask xTask xTaskDay -> {model | taskList = List.filter (\x -> not (x.taskName == xTask && x.taskDay == xTaskDay)) (model.taskList)
                                                        , featList = List.filter (\x -> not (x.taskName == xTask && x.taskDay == xTaskDay)) (model.featList) }

                    HighlightTask unstarredTask -> {model | featList =  { taskName = unstarredTask, taskDay = model.currentDay, visible = "visible"} :: (List.filter (\x -> x.taskName/=unstarredTask) (model.featList))
                                                        , taskList = (List.filter (\x -> x.taskName/=unstarredTask) (model.taskList))}

                    UnHighlightTask starredTask -> {model | featList = (List.filter (\x -> x.taskName/=starredTask) (model.featList))
                                                          , taskList =  { taskName = starredTask, taskDay = model.currentDay, visible = "visible"} :: model.taskList}
                    DayChange newDay -> {model | currentDay = newDay
                                                , featList = List.map (\x -> if x.taskDay == newDay then {x | visible = "visible"} else {x | visible = "hidden"}) (model.featList)
                                                , taskList = List.map (\x -> if x.taskDay == newDay then {x | visible = "visible"} else {x | visible = "hidden"}) (model.taskList)
                                        }


--on day change, filter the list to only include elements with that day
