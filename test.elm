import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import List exposing (map)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL

type alias Card =
  { name : String
  , inputs : List String
  , outputs : List String
  }


type alias Column =
  { index : Int
  , cards : List Card
  }

type alias Model =
  { columns : List Column
  }

init : (Model, Cmd Msg)
init =
  (Model
  [ Column 0
    [ Card "Add" ["A", "B"] ["Result"]
    , Card "Add" ["A", "B"] ["Result"]
    ]
  , Column 1
    [ Card "Add" ["A", "B"] ["Result"]
    , Card "Add" ["A", "B"] ["Result"]
    ]
  ]
  , Cmd.none
  )

-- UPDATE


type Msg
  = AddCard Int
  | Decrement


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (updateModel msg model
  , Cmd.none
  )

updateModel msg model =
  Model (updateColumns msg model.columns)

updateColumns : Msg -> List Column -> List Column
updateColumns msg columns =
  case msg of
    AddCard column ->
      map (\c ->
        if c.index == column then
          addCardToColumn c
        else
          c
          ) columns
    Decrement ->
      columns

addCardToColumn : Column -> Column
addCardToColumn column =
  Column column.index (column.cards ++ [ Card "Add" ["A", "B"] ["Result"] ])

-- VIEW


view : Model -> Html Msg
view model =
  div [canvasStyle] ((map columnView model.columns))

columnView : Column -> Html Msg
columnView column =
    div [columnStyle] ((map cardView column.cards) ++
    [ div [ onClick (AddCard column.index), buttonStyle ] [ text "Add Card" ]
    ])


cardView : Card -> Html Msg
cardView card =
  div [cardStyle] [
    div [cardHeaderStyle] [text card.name],
    cardColumnView "left" card.inputs,
    cardColumnView "right" card.outputs,
    clearFloat
  ]

clearFloat =
  div [style[
    ("clear", "both")
  ]] []

cardColumnView direction parameters =
  div [cardColumnStyle direction]
  (map (cardParameter direction) parameters)

cardParameter direction parameter =
  div [cardParameterStyle direction] [text parameter]

canvasStyle = style[
  ("position", "absolute"),
  ("background", "black"),
  ("height", "100%"),
  ("width", "100%")
  ]

columnStyle = style[
  ("float", "left")
  ]

cardStyle = style defaultElementAttributes

cardHeaderStyle = style [
  ("text-align", "center"),
  ("color", "white"),
  ("padding", "4px")
  ]

cardColumnStyle direction = style [
  ("text-align", direction),
  ("float", "left"),
  ("width", "50%")
  ]

cardParameterStyle direction = style [
  ("margin-" ++ direction, "15px")
  ]

buttonStyle = style (
  [ ("text-align", "center")
  , ("color", "white")
  ] ++ defaultElementAttributes)

defaultElementAttributes =
  [  ("background", "#666"),
    ("margin", "50px"),
    ("width", "200px"),
    ("font-family", "courier new"),
    ("border-radius", "4px")

  ]

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
