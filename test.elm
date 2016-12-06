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

type alias Model =
  { cards : List Card
  }

init : (Model, Cmd Msg)
init =
  (Model
  [ Card "Add" ["A", "B"] ["Result"]
  , Card "Add" ["A", "B"] ["Result"]
  ]
  , Cmd.none
  )

-- UPDATE


type Msg
  = AddCard
  | Decrement


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (Model (model.cards ++ [ Card "Add" ["A", "B"] ["Result"] ])
  , Cmd.none
  )



-- VIEW


view : Model -> Html Msg
view model =
  div [canvasStyle] ((map cardView model.cards) ++
  [ div [ onClick AddCard, buttonStyle ] [ text "Add Card" ]
  ])

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
